# Chat Feature Implementation Plan

## Overview
Add a 1-on-1 chat feature between users using Cloud Firestore with real-time messaging.

## Decisions Made
- **Data Model**: Subcollections - `users/{uid}/conversations/{conversationId}/messages/{messageId}`
- **User List**: Show all users from `users` collection, create conversation on first message
- **User Creation**: Auto-create user document on first login
- **Message Features**: Text only (timestamp, senderId, read status)

---

## Data Models

### User (`users/{uid}`)
```dart
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
}
```

### Conversation (`users/{uid}/conversations/{conversationId}`)
```dart
class Conversation {
  final String id;
  final List<String> participantIds; // always 2 users
  final String otherUserId; // cached for easy querying
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool isRead;
}
```

### Message (`users/{uid}/conversations/{conversationId}/messages/{messageId}`)
```dart
class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
}
```

---

## Implementation Tasks

### 1. Add Dependencies
- [ ] Add `cloud_firestore: ^5.0.0` to `pubspec.yaml`
- [ ] Run `flutter pub get`

### 2. Create Models
- [ ] Create `lib/chatapp/models/user.dart`
- [ ] Create `lib/chatapp/models/conversation.dart`
- [ ] Create `lib/chatapp/models/message.dart`

### 3. Create Firestore Service
- [ ] Create `lib/chatapp/services/firestore_service.dart`
  - `createOrUpdateUser(AppUser user)` - upsert user doc
  - `getAllUsers()` - Stream<List<AppUser>> for conversation list
  - `getOrCreateConversation(String currentUid, String otherUid)` - returns conversationId
  - `getMessages(String uid, String conversationId)` - Stream<List<Message>>
  - `sendMessage(String uid, String conversationId, Message message)` - add message
  - `markMessagesAsRead(String uid, String conversationId)` - batch update

### 4. Update Authentication Flow
- [ ] Modify `lib/main.dart` AuthGate to call `createOrUpdateUser()` after login
- [ ] Extract user creation logic to a service method

### 5. Update Dashboard Navigation
- [ ] Add AppBar action or bottom navigation to route to ConversationPage
- [ ] Update `lib/pages/dashboard.dart` to include chat navigation

### 6. Implement Conversation Page (`lib/chatapp/pages/conversation.dart`)
- [ ] StreamBuilder with `getAllUsers()` excluding current user
- [ ] ListView of users with name/email
- [ ] OnTap: call `getOrCreateConversation()` then navigate to ChatPage with conversationId and otherUser info

### 7. Implement Chat Page (`lib/chatapp/pages/chat.dart`)
- [ ] Accept `conversationId` and `otherUser` as constructor params
- [ ] StreamBuilder with `getMessages()` for real-time updates
- [ ] ListView.builder with messages (left/right alignment based on senderId)
- [ ] TextField + send button at bottom
- [ ] On send: call `sendMessage()` and clear input
- [ ] Auto-scroll to bottom on new messages
- [ ] Mark messages as read on page open

### 8. Routing & Navigation
- [ ] Define routes in MaterialApp or use Navigator.push
- [ ] Pass required parameters between pages

---

## Firestore Security Rules (to configure in Firebase Console)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId}/conversations/{conversationId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId}/conversations/{conversationId}/messages/{messageId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Edge Cases & Validation
- [ ] Handle empty user list (no other users registered)
- [ ] Handle network errors gracefully
- [ ] Prevent duplicate conversations between same two users
- [ ] Handle conversation creation race condition (two users starting chat simultaneously)
- [ ] Loading states for all async operations
- [ ] Empty message validation before sending

---

## Testing Checklist
- [ ] Two users can login on different devices/emulators
- [ ] User documents created in Firestore on first login
- [ ] Conversation list shows all other users
- [ ] Starting chat creates conversation in both users' subcollections
- [ ] Messages appear in real-time for both users
- [ ] Messages aligned correctly (sent vs received)
- [ ] Navigation works: Dashboard → Conversations → Chat
- [ ] Back navigation works correctly

---

## File Structure After Implementation
```
lib/
├── chatapp/
│   ├── models/
│   │   ├── user.dart
│   │   ├── conversation.dart
│   │   └── message.dart
│   ├── services/
│   │   └── firestore_service.dart
│   └── pages/
│       ├── login.dart
│       ├── conversation.dart
│       └── chat.dart
├── pages/
│   └── dashboard.dart
└── main.dart
```

---

## Dependencies to Add
```yaml
dependencies:
  cloud_firestore: ^5.0.0
  firebase_auth: ^7.0.1
  firebase_core: ^5.1.0
```