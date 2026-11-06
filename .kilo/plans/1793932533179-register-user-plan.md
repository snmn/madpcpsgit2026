# Register New User (Email/Password) Plan

## Goal
Add email/password registration to the Flutter app using Firebase Auth, mirroring existing login flow.

## Decisions
- New screen: `lib/chatapp/pages/registerPage.dart` (separate from login).
- Login page gets a "Create account" link navigating to register.
- Registration uses `FirebaseAuth.instance.createUserWithEmailAndPassword`.
- Fields: email, password, confirm password.
- Validation: reuse email regex; password min 6 chars; confirm must match.
- On success: sign in automatically (Firebase does) then navigate to `dashboard` removing previous routes.
- Error handling: map `FirebaseAuthException` codes to friendly messages like login.
- No Firestore profile write in this scope.

## Tasks
1. Create `registerPage.dart` with form, controllers, validators, `_register()` method, loading state, error snackbars.
2. Add navigation link on `loginPage.dart` to register page.
3. Ensure `main.dart` unchanged.
4. Add widget tests? Optional; follow existing test style if present.

## Risks
- Password policy: Firebase requires >=6 chars; enforce client-side.
- Duplicate email handling via `email-already-in-use`.
- Mounted checks after async gaps.

## Validation
- `flutter analyze` no new errors.
- Manual: register new email, verify lands on dashboard; duplicate email shows message.