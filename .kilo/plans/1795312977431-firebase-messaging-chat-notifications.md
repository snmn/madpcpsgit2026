# Plan: Firebase Cloud Messaging Push Notifications for Chat

## Goal
Send a Firebase Cloud Messaging (FCM) push notification to the recipient when they receive a chat message, on Android. The notification fires when `sendMessage()` writes a new message to Firestore; the recipient gets a system push (background/terminated) or in-app feedback (foreground). Tapping the notification opens the conversation.

## Project Context
- Flutter SDK `^3.10.4`; Dart 3.10.4
- Existing deps: `firebase_core ^5.1.0`, `firebase_auth ^7.0.1`, `cloud_firestore ^7.1.0`, `http 1.6.0`
- Firebase project: `chatappsecc` (`.firebaserc`); `lib/firebase_options.dart` has Android-only options
- `android/app/google-services.json` currently contains **placeholder** values — must be replaced with real FCM config from Firebase Console
- Chat pages: `lib/chatapp/pages/conversation.dart` (lists users) → `lib/chatapp/pages/chat.dart` (1:1 chat)
- `lib/chatapp/services/chat_service.dart` — `sendMessage()` writes message + updates conversation in a transaction
- Models: `lib/chatapp/models/app_user.dart` (uid, email, createdAt); `lib/chatapp/models/chat_message.dart`
- Entry: `lib/main.dart` — `Firebase.initializeApp(options: DefaultFirebaseOptions.android)`, `authStateChanges` routes LoginPage vs `dashboard()`
- `firestore.rules`: `users/{uid}` readable by all authenticated, writable by owner; conversations/messages participant-scoped
- No `firebase_messaging` dependency; no FCM token storage; no push infrastructure; no `functions/` directory

## Plan File
`.kilo/plans/1795312977431-firebase-messaging-chat-notifications.md`

## Decisions (confirmed)
1. **Trigger:** Client-side in `ChatService.sendMessage()` after the Firestore transaction commits. The sender's app reads the recipient's FCM token and asks a secure callable function to send the push (message send never blocks on push; push is best-effort).
2. **Platform:** Android only. iOS (APNs, `GoogleService-Info.plist`, Xcode push capabilities) is out of scope.
3. **Suppression:** None — always push, even if recipient has the chat open (foreground gets in-app feedback instead).
4. **Token storage:** `users/{uid}.fcmToken` (optional `String?`). Refreshed on app start/login and via `onTokenRefresh`. Existing `firestore.rules` already let the owner update their doc and let authenticated users read user docs (sender needs recipient token), so no rule change is strictly required; flagged as a privacy note.
5. **FCM send:** A **Callable Cloud Function** `sendPushNotification` (Node.js, `firebase-admin`) performs the actual FCM send. The Flutter client calls it via `firebase_functions` `httpsCallable` so the server key/credentials never ship in the client. Direct client-to-FCM HTTP is not used (requires OAuth tokens unsuitable for a client).
6. **Foreground:** `FirebaseMessaging.onMessage` shows a `SnackBar` via a root `NavigatorState` key (no extra dependency). Chat `StreamBuilder` still auto-updates the open conversation.
7. **Background/terminated tap:** `onMessageOpenedApp` + `getInitialMessage()` navigate to `ChatPage(otherUser: <AppUser looked up by senderId>)`. Requires a `GlobalKey<NavigatorState>` exposed by `MyApp`.

## Tasks
1. Add `firebase_messaging` and `firebase_functions` to `pubspec.yaml`; run `flutter pub get`
2. Initialize Firebase project functions: `firebase init functions` (JavaScript) if `functions/` missing; write `functions/src/index.js` + `functions/package.json` (`firebase-admin`, `firebase-functions`); deploy with `firebase deploy --only functions`
3. Replace placeholder `android/app/google-services.json` with real config downloaded from Firebase Console (Project Settings > Add Android app, package `com.example.demopcpsseca`)
4. `lib/chatapp/models/app_user.dart` — add optional `fcmToken` field (read from snapshot; keep `toMap` unchanged)
5. `lib/chatapp/services/notification_service.dart` (new) — `NotificationService`:
   - `init(navigatorKey)`: get FCM token, write `users/{uid}.fcmToken`, listen `onTokenRefresh` to update token, register top-level `onBackgroundMessage` handler, subscribe `onMessage` (foreground SnackBar), subscribe `onMessageOpenedApp` (navigate to chat)
   - `sendPushNotification(recipientToken, title, body, data)`: call callable function `sendPushNotification`
6. `lib/chatapp/services/chat_service.dart` — extend `sendMessage({..., recipientId})`: after transaction commits, read `users/{recipientId}.fcmToken`; if present, call `NotificationService.sendPushNotification(...)` fire-and-forget (errors swallowed so message send always succeeds)
7. `lib/main.dart` — initialize `Firebase` (already), then `NotificationService.init(navigatorKey)`; register top-level background handler; handle `FirebaseMessaging.instance.getInitialMessage()` before `runApp` for terminated-state taps; add `navigatorKey` to `MaterialApp`
8. `lib/chatapp/pages/chat.dart` — pass `recipientId` (= `widget.otherUser.uid`) into `sendMessage`
9. `android/app/src/main/AndroidManifest.xml` — add `android.permission.POST_NOTIFICATIONS` (runtime request on API 33+ handled by plugin/Dart)
10. `firestore.rules` — no change required (owner update + authenticated read already allowed); add privacy note about `fcmToken` readability

## File Changes

### `pubspec.yaml` (edit)
```
dependencies:
  ...
  firebase_messaging: ^5.0.0
  firebase_functions: ^6.0.0
```
Run `flutter pub get`; adjust versions if `flutter analyze` complains.

### `functions/src/index.js` (new)
```js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendPushNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Unauthenticated');
  const { token, title, body, data: payload } = data;
  if (!token) throw new functions.https.HttpsError('invalid-argument', 'Missing token');
  await admin.messaging().send({ token, notification: { title, body }, data: payload || {} });
  return { success: true };
});
```

### `functions/package.json` (new)
```json
{
  "name": "chatapp-functions",
  "description": "Cloud Functions for chatappsecc",
  "scripts": {},
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^6.0.0"
  }
}
```
Deploy: `firebase deploy --only functions` (requires `firebase-tools` and `firebase login`).

### `lib/chatapp/models/app_user.dart` (edit)
Add `final String? fcmToken;` to constructor + `fromSnapshot` read (`data['fcmToken'] as String?`).

### `lib/chatapp/services/notification_service.dart` (new)
`NotificationService` class as described in Decision 5. Exposes `init(GlobalKey<NavigatorState> navigatorKey)` and `sendPushNotification(...)`.

### `lib/chatapp/services/chat_service.dart` (edit)
`sendMessage({required conversationId, required senderId, required recipientId, required text})` — after transaction, `await _firestore.collection('users').doc(recipientId).get()` → `data()['fcmToken']`; if present, `NotificationService.instance.sendPushNotification(token, title, body, {conversationId, senderId})`. Wrap in try/catch; never throw.

### `lib/main.dart` (edit)
- Create `final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();`
- After `Firebase.initializeApp(...)`: `NotificationService.init(navigatorKey);`
- Top-level background handler `FirebaseMessaging.onBackgroundMessage(_backgroundHandler)` (must be top-level, no `this`)
- Before `runApp`: `await FirebaseMessaging.instance.getInitialMessage()` → if present, store initial route data to navigate after first frame
- `MaterialApp(navigatorKey: navigatorKey, ...)`

### `lib/chatapp/pages/chat.dart` (edit)
`_sendMessage()` calls `_chatService.sendMessage(conversationId: ..., senderId: ..., recipientId: widget.otherUser.uid, text: ...)`.

### `android/app/src/main/AndroidManifest.xml` (edit)
Add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`.

### `android/app/google-services.json` (edit)
Replace placeholder block with real `google-services.json` from Firebase Console.

## Validation Steps
1. `flutter pub get`
2. `flutter analyze` — no new errors
3. Replace `google-services.json` placeholders with real FCM config (required; otherwise Android build/runtime fails)
4. Deploy callable function: `firebase deploy --only functions`
5. Run on Android emulator/device (API 21+; POST_NOTIFICATIONS runtime on API 33+)
6. Sign in two accounts (A and B); confirm `users/{uid}.fcmToken` is written on app start
7. From A, open conversation with B, send a message → B receives FCM system push when app is backgrounded/terminated
8. From A, send message while B is in foreground → B sees in-app `SnackBar` feedback and chat stream updates
9. Tap the push notification → app opens and navigates to the A↔B chat conversation
10. Send message → confirm push is best-effort: message still sends even if push function is unavailable

## Open Questions / User Input
- None — all decisions confirmed. Foreground feedback is a `SnackBar`; a richer local notification (`flutter_local_notifications`) can be added later.

## Risks
- Placeholder `google-services.json` breaks the Android build/runtime; real config must come from Firebase Console before building.
- FCM send cannot be done securely from the client (no server credentials in app) → the callable Cloud Function is mandatory even though the trigger is client-initiated.
- Background message handler must be a top-level function (cannot reference `NotificationService` instance); design uses a static/top-level handler that routes via the service singleton.
- Notification-tap navigation depends on `navigatorKey` being set before any route pushes; ensure `MaterialApp` uses it.
- iOS push is NOT covered (no APNs cert, no `GoogleService-Info.plist`, no Xcode push capability) per the Android-only decision.
- `fcmToken` is readable by any authenticated user (consistent with existing `users` read rule); acceptable for this app, flagged for future hardening.
