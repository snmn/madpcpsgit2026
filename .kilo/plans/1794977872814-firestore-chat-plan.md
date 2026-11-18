# Firestore 1:1 Chat Implementation Plan

## Goal
Add a Firebase Firestore-backed 1:1 conversation/chat feature and route users from the news dashboard to the conversation list.

## Confirmed decisions
- **Chat scope:** 1:1 direct chats between authenticated users (not group threads). Conversation list shows other users from Firestore; tapping a user opens/creates a direct chat. (Matches `lib/chatapp/pages/conversation.dart:16-17`.)
- **Dashboard entry:** Add a `FloatingActionButton` on `lib/pages/dashboard.dart` that navigates to the conversation page.
- **Data/bootstrap:** Add `cloud_firestore` dependency and persist `users/{uid}` profile docs on sign-up and sign-in so a user directory exists for chat.

## Current context / constraints
- Firebase initialized in `lib/main.dart:6-11` via `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`. Android options in `lib/firebase_options.dart`.
- Auth: email/password via `firebase_auth` in `lib/chatapp/pages/loginPage.dart` and `lib/chatapp/pages/registerPage.dart`; both navigate to `dashboard()` on success (`loginPage.dart:44-49`, `registerPage.dart:45-50`).
- `pubspec.yaml` has `firebase_auth`, `firebase_core` but **no** `cloud_firestore` (`pubspec.yaml:30-45`).
- Chat UI placeholders: `lib/chatapp/pages/conversation.dart` (empty `Column` scaffold) and `lib/chatapp/pages/chat.dart` (empty `Column` scaffold, `const Chat({super.key})`).
- Dashboard (`lib/pages/dashboard.dart:171-233`) returns a `Scaffold` with an empty `AppBar` and a `FutureBuilder` body; no FAB yet.
- `lib/core/staticfile.dart` holds shared static state (e.g. selected article); use only if helpful, prefer passing route args for chat identity.
- Unrelated working-tree changes noted (`macos/Flutter/GeneratedPluginRegistrant.swift`, AM markers on chat placeholders); do not revert or include unless required.

## Firestore data model (recommended)

### `users/{uid}`
Written/merged on successful register and login (ensures existing auth users get a profile on next login).
- `uid` (string)
- `email` (string, lowercased/trimmed as stored)
- `displayName` (string, nullable/derived fallback e.g. email prefix)
- `photoUrl` (string, nullable, optional)
- `createdAt` (server timestamp, set on first create)
- `updatedAt` (server timestamp)

### `conversations/{conversationId}` (1:1)
Use a deterministic `conversationId` to prevent duplicate threads, e.g. sorted participant UIDs joined: `min(uidA,uidB)_max(uidA,uidB)`.
- `participantIds` (array<string>, exactly 2 UIDs) — required for querying "my conversations" and for security rules.
- `participantInfo` (map, optional but useful): `{uid: {email/displayName}}` snapshot for list previews.
- `lastMessage` (string, nullable)
- `lastMessageAt` (timestamp, nullable)
- `lastSenderId` (string, nullable)
- `createdAt`, `updatedAt` (timestamps)

Create/get conversation on first open or on first send via `set(..., SetOptions(merge: true))`/transaction as appropriate.

### `conversations/{conversationId}/messages/{messageId}`
- `senderId` (string, current user uid)
- `text` (string)
- `createdAt` (server timestamp / client timestamp fallback for ordering)
- `type` (string, default `text`, for future-proofing; optional in v1)

## Implementation tasks (ordered)

1. **Dependencies & project wiring**
   - Add `cloud_firestore` (compatible with existing Firebase core/auth versions) to `pubspec.yaml` and fetch deps. Regenerate platform plugin registrants as needed by Flutter tooling.
   - Confirm Android/iOS/other platform minsdk/Pod constraints are satisfied for the chosen Firestore version; adjust only if required.

2. **User profile persistence (auth flow integration)**
   - In `lib/chatapp/pages/registerPage.dart`: after `createUserWithEmailAndPassword` succeeds, upsert `users/{uid}` in Firestore (merge) before/alongside navigation. Keep existing error handling/navigation semantics.
   - In `lib/chatapp/pages/loginPage.dart`: after `signInWithEmailAndPassword` succeeds, upsert/merge `users/{uid}` (and `updatedAt`, email) so pre-existing or out-of-sync users appear in the directory.
   - Use `FirebaseAuth.instance.currentUser` / credential user for uid/email. Do not log secrets.
   - Consider a small helper/service (e.g. under `lib/chatapp/` or `lib/controller/`) for Firestore user/conversation operations to avoid duplication; follow existing project structure/conventions.

3. **Conversation list page (`lib/chatapp/pages/conversation.dart`)**
   - Rename/implement to a properly-cased widget (e.g. `ConversationPage`) consistent with project style; update imports/usages accordingly.
   - Require authenticated context (`FirebaseAuth.instance.currentUser`); handle signed-out state defensively.
   - Stream/query Firestore `users` collection to list other users (exclude current uid). Display email/display name; handle empty/loading/error states.
   - On user tap: compute deterministic `conversationId`, ensure/create `conversations/{conversationId}` with `participantIds`/metadata, then navigate to chat screen passing peer + conversation identifiers.
   - Add an `AppBar` (title like "Conversations" / "Chats") for basic navigation/usability.

4. **Chat page (`lib/chatapp/pages/chat.dart`)**
   - Accept required parameters (peer user info and/or `conversationId`, current uid) via constructor; update call sites.
   - UI: message list (Firestore stream of `messages` ordered by `createdAt` ascending/descending with reverse list as preferred) distinguishing my messages (right/aligned/styled) vs other (left) per placeholder comments.
   - Input: `TextFormField`/`TextField` + send action at bottom; trim/ignore empty sends; disable while sending as appropriate.
   - Send: add message doc to `messages` subcollection and update parent conversation `lastMessage`, `lastMessageAt`, `lastSenderId`, `updatedAt` (prefer batched write/transaction for consistency).
   - Handle loading/empty/error states and null timestamps during server-timestamp latency (`FieldValue.serverTimestamp()` pending values).

5. **Dashboard routing (`lib/pages/dashboard.dart`)**
   - Add `floatingActionButton` to the `Scaffold` (`:171-233`) that pushes `ConversationPage` via `MaterialPageRoute` (e.g. chat/message icon, tooltip). Import the conversation page.
   - Ensure FAB placement does not break existing scroll/layout behavior of the news lists (verify in UI).

6. **Firestore indexes & security (operational)**
   - Queries: `users` listing may need ordering; "my conversations" (if added later) needs `participantIds` array-contains + `lastMessageAt` desc composite index — note in validation/deploy steps.
   - Define/verify Firestore Security Rules so authenticated users can read/write only their own user doc as appropriate and only access conversations/messages where their uid is in `participantIds`. This is critical but may be managed outside this repo (Firebase console/rules files) — confirm location during implementation.

## Edge cases & failure modes
- User doc missing for legacy accounts: mitigated by login-time upsert (task 2).
- Duplicate conversation docs: mitigated by deterministic `conversationId` (do not create random IDs for 1:1).
- Empty/whitespace messages, rapid double-send, send failures (surface error, keep text or clear intentionally).
- Firestore permission-denied or offline/network errors: show user-visible error/empty states.
- `createdAt` null while pending server timestamp: order/query defensively.
- Self-chat (current user appears in list): exclude current uid from list.

## Validation plan
- Run `flutter pub get` after dependency changes; run `flutter analyze` and project tests if present (discover via repo). Run any lint/typecheck commands specified by project config.
- Manual flows (Android/emulator or configured device): register new user -> `users` doc created; login existing user -> doc upserted; dashboard FAB opens conversation list; list shows other users; open chat -> conversation doc created; send/receive messages in realtime between two accounts; restart app and verify persistence/order.
- Verify Firestore rules/index behavior in Firebase console/emulator if available.

## Risks / open items (explicit)
- **Security rules & indexes** not visible in-repo: implementation must align with deployed rules; permission errors will block reads/writes until rules allow `participantIds`-scoped access.
- **Existing AM/staged placeholder edits** in `lib/chatapp/pages/chat.dart` and `lib/chatapp/pages/conversation.dart`: reconcile during implementation without discarding intended work.
- **Display identity:** v1 can use `email` (and/or prefix) as display name since auth currently collects no profile name; richer profiles are out of scope.
- Out of scope unless requested: group chats, read receipts/presence, push notifications, pagination, media messages, conversation-list screen based on existing threads (v1 lists users per requirement).
