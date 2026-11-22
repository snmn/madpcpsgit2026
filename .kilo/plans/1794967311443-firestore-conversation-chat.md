# Plan: Firestore 1:1 Chat (conversation + chat pages)

## Goal
Add Cloud Firestore-backed real-time 1:1 chat between two users:
- Conversation page: list all registered users (from Firestore `users` collection), tap to open a chat
- Chat page: real-time message stream between current user and selected user (left/right bubbles, text composer, send)
- Route from dashboard to conversation page (body tile or FAB)
- Complete signup in loginPage.dart (email/password only) writing `users/{uid}` to Firestore with `if (!mounted) return;` + error message pattern
- Participant-scoped Firestore security rules

## Current state
- `lib/chatapp/pages/conversation.dart` — empty stub (comment: "list of users from firestore database")
- `lib/chatapp/pages/chat.dart` — empty stub (comments for left/right bubbles + text field)
- `lib/chatapp/pages/loginPage.dart` — login works; signup `TextButton` has empty `onPressed: () {}`
- `lib/pages/dashboard.dart` — news feed + logout; no chat route
- `pubspec.yaml` — `firebase_core ^5.1.0`, `firebase_auth ^7.0.1`; no `cloud_firestore`
- `firestore.rules` / `firebase.json` — Firestore configured; rules currently permissive (`allow read, write: if true`)
- `lib/main.dart` — `authStateChanges` routes to `loginPage` or `dashboard`

## Decisions (confirmed)
- Dashboard entry: body tile or FAB → conversation page
- Signup: email/password only (no displayName); chat renders email (or email prefix before `@`) as the user name
- Conversation ID: deterministic `sorted([uidA, uidB]).join('_')` so both users share one chat document
- Schema: `users/{uid}`; `conversations/{convId}` + subcollection `conversations/{convId}/messages/{msgId}`
- Mount guard pattern: `if (!mounted) return;` then show error snackbar ("Unable to create account. Please try again.")

## Tasks
1. Add `cloud_firestore` (version compatible with Dart SDK 3.10.4, e.g. `^7.1.0`) to `pubspec.yaml`; run `flutter pub get`
2. Create `lib/chatapp/models/app_user.dart` — `AppUser` (uid, email, createdAt)
3. Create `lib/chatapp/models/chat_message.dart` — `ChatMessage` (id, conversationId, senderId, text, createdAt, read)
4. Create `lib/chatapp/services/chat_service.dart` — `conversationIdFor(uidA, uidB)`, `usersStream()` (excludes current user), `createOrGetConversation(otherUid)`, `messagesStream(conversationId)` (real-time, ordered by createdAt), `sendMessage(conversationId, senderId, text)` (transactional: write message + update conversation `updatedAt`/`lastMessage`)
5. Complete signup in `loginPage.dart`: email/password/confirm validation; `createUserWithEmailAndPassword`; write `users/{uid}`; `if (!mounted) return;` guard; error snackbar "Unable to create account. Please try again."
6. Implement `conversation.dart`: `StreamBuilder` over `usersStream()`, list all users except current user, tap → `Navigator.push` to `chat.dart` with the other user
7. Implement `chat.dart`: `StreamBuilder` over `messagesStream()`, left/right bubbles by `senderId == currentUid`, `TextField` + send button, auto-scroll to bottom, loading state
8. Add dashboard route: body tile or FAB → `Navigator.push` to `conversation()`
9. Update `firestore.rules`: `users` readable by all authenticated users, writable by owner; `conversations`/`messages` readable/writable only by document participants
10. `flutter analyze` — no new errors; enable Firestore in Firebase console (`chatappsecb-6525f`) and deploy rules (`firebase deploy --only firestore:rules`)

## Validation
- Sign up two accounts; confirm `users/{uid}` documents created in Firestore
- From dashboard, open the conversation list; the other registered user appears
- Open a chat; send messages both directions; confirm real-time sync and correct bubble sides
- `flutter analyze` reports no new issues

## Open questions
- None (all decisions confirmed above)
