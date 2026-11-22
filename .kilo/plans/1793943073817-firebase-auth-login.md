# Firebase Auth Email/Password Login Implementation Plan

## Goal
Implement Firebase Authentication login with email and password for the Flutter app `demopcpsseca`, replacing the current placeholder login navigation with real auth.

## Project Context
- Flutter project at `C:\Users\Lenovo\StudioProjects\demopcpsseca`
- SDK: `^3.10.4`
- Existing deps already present: `firebase_core: ^5.1.0`, `firebase_auth: ^7.0.1`
- `firebase.json` already enables `auth.providers.emailPassword: true`
- `.firebaserc` project id: `chatappsecc`
- Current login page: `lib/chatapp/pages/loginPage.dart` (placeholder, navigates to `dashboard()` on tap)
- Current entry: `lib/main.dart` sets `home: loginPage()`
- Android uses Kotlin DSL `build.gradle.kts` / `settings.gradle.kts`
- No `google-services.json` present
- No `lib/firebase_options.dart` present
- No AGENTS.md present

## Plan File
`.kilo/plans/1793943073817-firebase-auth-login.md`

## Decisions
1. **Auth state management**: Use `FirebaseAuth.instance.authStateChanges()` stream in `main.dart` to decide the initial route (login vs dashboard).
2. **Firebase config**: Generate `lib/firebase_options.dart` with placeholder values to be filled from Firebase Console project settings.
3. **Android config**: Add `google-services.json` to `android/app/`, apply `com.google.gms.google-services` plugin in `android/app/build.gradle.kts`, add classpath in `android/build.gradle.kts`.
4. **Auth service**: New file `lib/services/auth_service.dart` wrapping `FirebaseAuth` sign-in/sign-out with error handling.
5. **Login page**: Rewrite `lib/chatapp/pages/loginPage.dart` with `TextEditingController`s for email/password, auth call, loading state, error `SnackBar`, and route to dashboard on success.
6. **Dashboard guard**: Keep `dashboard()` accessible only when authenticated (handled by auth state listener in main).

## File Changes

### 1. `lib/firebase_options.dart` (new)
Firebase config constants per platform. Populate from Firebase Console > Project Settings > General > Your apps.
```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
static const FirebaseOptions options = FirebaseOptions(
  apiKey: '<YOUR_API_KEY>',
  authDomain: 'chatappsecc.firebaseapp.com',
  projectId: 'chatappsecc',
  storageBucket: 'chatappsecc.appspot.com',
  messagingSenderId: '<YOUR_SENDER_ID>',
  appId: '<YOUR_APP_ID>',
);
```

### 2. `lib/services/auth_service.dart` (new)
- `Future<UserCredential> signInWithEmailPassword({required String email, required String password})`
- `Future<void> signOut()`
- `Stream<User?> get authStateChanges`
- Wrap FirebaseAuth exceptions into readable messages (`auth/invalid-email`, `auth/user-disabled`, `auth/user-not-found`, `auth/wrong-password`, `auth/too-many-requests`, `auth/operation-not-allowed`, `auth/network-request-failed`).

### 3. `lib/chatapp/pages/loginPage.dart` (edit)
- Add `AuthService` instance and two `TextEditingController`s (email, password).
- `obscureText` toggle for password.
- Loading indicator while signing in.
- On success: `Navigator.pushReplacement` to `dashboard()`.
- On failure: show `SnackBar` with error message.
- Add "Forgot password?" and "Sign up" placeholder links (out of scope to implement fully, but stubbed).

### 4. `lib/main.dart` (edit)
- Initialize `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
- `StreamBuilder<User?>` on `FirebaseAuth.instance.authStateChanges()`.
- `home: user == null ? loginPage() : dashboard()`.

### 5. `android/build.gradle.kts` (edit)
- Add classpath `com.google.gms.google-services:4.4.2` (version compatible with Flutter Gradle plugin).

### 6. `android/app/build.gradle.kts` (edit)
- Apply `com.google.gms.google-services` plugin at bottom.
- Ensure `minSdkVersion >= 21` (Firebase Auth requirement).

### 7. `android/app/google-services.json` (new)
- Download from Firebase Console > Project Settings > Service accounts / General > Add app > Android.
- Place at `android/app/google-services.json`.

## Validation Steps
1. `flutter pub get`
2. `flutter analyze` — no errors
3. Run on Android emulator/device
4. Register/sign in with email+password → navigates to dashboard
5. Wrong credentials → SnackBar shows error
6. App restart → remains signed in (auth state restored), shows dashboard
7. Sign out (button to be added to dashboard) → returns to login

## Open Questions / User Input Needed
- Firebase project web/Android config values (apiKey, appId, messagingSenderId) — must come from Firebase Console; placeholders used in plan.
- Whether to add a sign-out button to `dashboard.dart` now or leave for follow-up.
- Whether to implement "Forgot password" / "Sign up" flows now or keep as stubs.

## Risks
- `google-services.json` missing → app crashes at runtime on Android; must be obtained from Firebase Console.
- `firebase_options.dart` placeholder values must be replaced before `flutterfire configure` or manual config works.
- `firebase_auth: ^7.0.1` is a major version; verify API matches (`signInWithEmailAndPassword`, `authStateChanges`).