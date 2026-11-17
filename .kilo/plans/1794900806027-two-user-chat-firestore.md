# Two-User Chat (Firestore) — Implementation Plan

## Goal
Add real-time one-to-one chat between two authenticated users using Cloud Firestore. The `chat.dart` and `conversation.dart` stubs become working screens.

## Decisions (confirmed with user)
- User directory: top-level `users` collection (doc per auth user). Populated on signup.
- Message storage: top-level `chats` collection with a `messages` subcollection.
- Chat list UX: searchable list of all users (excluding me) to start a chat.
- Chat identity: `chatId = "<uidA>_<uidB>"` with uids sorted lexicographically.

## Prerequisites (manual, before implementation)
1. Enable Cloud Firestore in the Firebase console for project `chatappsecb-6525f` (test mode during development).
2. Publish the security rules from `firestore.rules` (see step 7).
3. Add the `cloud_firestore` dependency (step 1) — no other packages needed.

## Data model
```
users/{uid}
  name: string          (displayName; falls back to email prefix)
  email: string
  createdAt: Timestamp  (serverTimestamp)

chats/{chatId}          (chatId = sorted uids joined by "_")
  participants: [uid, uid]
  participantNames: {uid: name, ...}
  createdAt: Timestamp
  lastMessage: string
  lastMessageAt: Timestamp
  lastSenderUid: string
  messages/{messageId}  (auto-id)
    senderId: string
    senderName: string
    text: string
    createdAt: Timestamp  (serverTimestamp)
```

## Implementation steps

### 1. Add dependency
- In `pubspec.yaml`, add `cloud_firestore: ^7.2.0` under `dependencies` (compatible with the pinned `firebase_core ^5.1.0`). Run `flutter pub get`.

### 2. New files (all under `lib/chat/`)
- `lib/chat/models/chat_message.dart` — `ChatMessage` model with `fromMap`/`toMap`, `text`, `senderId`, `senderName`, `createdAt`.
- `lib/chat/models/app_user.dart` — `AppUser` model: `uid`, `name`, `email`, with `fromMap`.
- `lib/chat/services/chat_service.dart` — single source of Firestore logic:
  - `static String chatIdFor(String a, String b)` → sorted uids joined by `_`.
  - `Stream<List<AppUser>> usersStream()` — all users ordered by `name`; caller filters out self.
  - `Stream<QuerySnapshot> messagesStream(String chatId)` — `messages` subcollection ordered by `createdAt`.
  - `Future<void> sendMessage({chatId, sender, receiverName, text})` — `add` to messages + `set(..., merge: true)` on the chat doc updating `lastMessage`, `lastMessageAt`, `lastSenderUid`, `participants`, `participantNames` (run as a batched write so the chat doc and message stay consistent).
  - `Future<void> ensureChat(String chatId, List<String> uids, Map<String,String> names)` — idempotent chat doc creation (only writes `createdAt` on first create).

### 3. Signup writes a user profile
- In `lib/chat/pages/loginPage.dart`, `_SignupPageState._signUp`: after `updateDisplayName` + `reload`, write `users/{uid}` with `{name, email, createdAt: FieldValue.serverTimestamp()}` via `FirebaseFirestore.instance` (add the import). Keep existing auth flow and error handling.

### 4. Implement `lib/chat/pages/chat.dart`
- `StatefulWidget` that resolves the current user (`FirebaseAuth.instance.currentUser`); if `null`, show an empty state (defensive; `MyApp` normally gates this).
- `StreamBuilder<List<AppUser>>` from `ChatService.usersStream()`, filtered to exclude the current uid and matched against a `TextEditingController` search query (case-insensitive on `name`/`email`).
- Each `ListTile` shows name + email and, on tap, pushes `conversation` with `otherUser` (uid + name) and the derived `chatId`.
- Follow existing file conventions (lowercase class names are used across this project — keep `chat` to match, or rename to `ChatPage` only if the user prefers; default: keep `chat`).

### 5. Implement `lib/chat/pages/conversation.dart`
- Constructor takes `otherUser` (uid, name) and `chatId` (or compute it from the two uids).
- `StreamBuilder<QuerySnapshot>` on the `messages` subcollection ordered by `createdAt`; build a `ListView` (reverse: true) of message bubbles:
  - `senderId == currentUser.uid` → right-aligned, blue bubble (matches the app's blue accent).
  - otherwise → left-aligned, grey bubble; optionally show sender name.
- Bottom `TextField` + send button; on submit calls `ChatService.sendMessage(...)`. Clear the field immediately; guard against empty/whitespace-only sends. Show loading state on the send button.
- Use `SafeArea`/`MediaQuery.viewInsets` so the composer is not covered by the keyboard. Keep the existing `Column` placeholder structure replaced by an `Expanded` list + composer row.

### 6. Dashboard wiring
- `lib/pages/dashboard.dart` already navigates to `chat()` from the chat icon. No change needed unless the constructor of `chat` changes (it stays `const chat()`).

### 7. Security rules (`firestore.rules` at repo root)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function signedIn() { return request.auth != null; }

    match /users/{uid} {
      allow read: if signedIn();
      allow write: if signedIn() && request.auth.uid == uid;
    }

    match /chats/{chatId} {
      allow read: if signedIn()
        && request.auth.uid in resource.data.participants;
      allow create: if signedIn()
        && request.auth.uid in request.resource.data.participants
        && request.resource.data.participants.size() == 2;
      allow update: if signedIn()
        && request.auth.uid in resource.data.participants
        && request.auth.uid in request.resource.data.participants;

      match /messages/{messageId} {
        allow read: if signedIn()
          && request.auth.uid in
             get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
        allow create: if signedIn()
          && request.auth.uid == request.resource.data.senderId
          && request.auth.uid in
             get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
        allow update, delete: if false;
      }
    }
  }
}
```
- This enforces: only the two participants read/write their chat; only the sender can create their own messages; messages are immutable.
- Deploy: `firebase deploy --only firestore:rules` (requires Firebase CLI login and a `firebase.json` `firestore.rules` entry — add `"firestore": {"rules": "firestore.rules"}`).

### 8. Validation
- `flutter analyze` — zero new issues.
- Manual two-account test: sign up Account A, sign up Account B (two devices/emulators or `flutter run` on two targets), confirm B appears in A's chat list and vice-versa, exchange messages both directions, confirm real-time delivery and correct bubble alignment.
- Negative check: with test rules, confirm a third signed-in user cannot read the A↔B messages subcollection (attempt via a throwaway read in code or the Firestore console).

## Risks / notes
- `users` list is global (all signed-up users see each other). Acceptable for this app; if privacy matters later, add a `searchable` flag or contact list.
- `chatId` uses raw uids joined by `_`; uids are alphanumeric so no separator collision.
- No pagination: the full users list and the full message history load at once. Fine for a demo; add `limit`/`startAfter` later if histories grow.
- Offline behavior is handled by Firestore's built-in persistence (no extra code).
- Class names stay lowercase (`chat`, `conversation`) to match the existing codebase style.

## Out of scope
- Push notifications, unread counts/read receipts, typing indicators, image/file messages, group chats, message deletion/editing, user profile editing, password reset, and Firebase Functions.