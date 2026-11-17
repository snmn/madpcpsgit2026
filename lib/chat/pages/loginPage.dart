import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});
  @override
  State<loginPage> createState() => _loginPageState();
}
class _loginPageState extends State<loginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty || password.isEmpty || !emailPattern.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email and password.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The authStateChanges stream in MyApp routes to the dashboard.
      if (!mounted) return;
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Email or password is incorrect.',
        'invalid-email' => 'Enter a valid email address.',
        'user-disabled' => 'This account is disabled.',
        'network-request-failed' => 'Network error. Check your connection and try again.',
        _ => 'Unable to sign in. Please try again.',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to sign in. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
            children: [
                Container(
                height: size.height/1.5,
                width: size.width,
                child: Image.network(
                  fit: BoxFit.fitWidth,
                  "https://img.magnific.com/free-vector/messaging-application-abstract-concept-illustration_335657-3870.jpg?semt=ais_hybrid&w=740&q=80"
                ),
              ),
                Positioned(
                  bottom: -5,
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("eGUFF",
                        style: TextStyle(
                          color: Color(0xffCD86E4),
                          fontSize: 70,fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
            ],
          ),
            Container(
            width: size.width/1.1,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xffEAEDF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(" Email: "),
                Container(
                  width: size.width/1.8,
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],

                    decoration: InputDecoration(
                      hint: Text("abc@gmail.com"),
                      border: InputBorder.none
                    ),
                  ),
                )
              ],
            ),
          ),
            Container(
              width: size.width/1.1,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xffEAEDF6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(" Password: "),
                  Container(
                    width: size.width/1.8,
                    child: TextField(
                      controller: _password,
                      autofillHints: const [AutofillHints.password],
                      obscureText: true,
                      decoration: InputDecoration(
                          hint: Text("keep it a secret"),
                          border: InputBorder.none
                      ),
                    ),
                  ),

                ],
              ),
            ),
            GestureDetector(
              onTap: _loading ? null : _signIn,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(
                    left: 20,right: 20,
                    top: 12,bottom: 12
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: _loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text("Login".toUpperCase(),
                style: TextStyle(color: Colors.white,
                fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("forget password? "),
                Text.rich(
                  TextSpan(
                    text: "Register Now",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (name.isEmpty) {
      _showMessage('Enter your name.');
      return;
    }
    if (!emailPattern.hasMatch(email)) {
      _showMessage('Enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }
    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() => _loading = true);
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      // Auth creates the account first; Firestore creates the collection only
      // after this document write succeeds.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // authStateChanges in MyApp routes to the dashboard.
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseException catch (error) {
      if (!mounted) return;
      final detail = switch (error.code) {
        'permission-denied' =>
          'Firestore denied the profile write. Check the deployed Firestore rules.',
        'unavailable' =>
          'Firestore is unavailable. Check your connection and try again.',
        'not-found' =>
          'Firestore is not set up for this Firebase project.',
        _ => 'Firestore error (${error.code}): ${error.message ?? 'Unknown error.'}',
      };
      _showMessage(credential?.user != null
          ? 'Account created, but the user profile was not saved. $detail'
          : detail);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'email-already-in-use' => 'This email is already registered.',
        'invalid-email' => 'Enter a valid email address.',
        'weak-password' => 'Choose a stronger password.',
        'operation-not-allowed' => 'Email sign-up is disabled.',
        'network-request-failed' =>
          'Network error. Check your connection and try again.',
        _ => 'Unable to create account. Please try again.',
      };
      _showMessage(message);
    } catch (error) {
      if (!mounted) return;
      _showMessage(credential?.user != null
          ? 'Account created, but profile setup failed: $error'
          : 'Unable to create account: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 5,
              width: size.width,
              alignment: Alignment.center,
              child: Text(
                "eGUFF",
                style: TextStyle(
                  color: Color(0xffCD86E4),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _field(
              size: size,
              label: " Name: ",
              controller: _name,
              hint: "Your name",
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              obscureText: false,
            ),
            _field(
              size: size,
              label: " Email: ",
              controller: _email,
              hint: "abc@gmail.com",
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              obscureText: false,
            ),
            _field(
              size: size,
              label: " Password: ",
              controller: _password,
              hint: "keep it a secret",
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: _obscurePassword,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            _field(
              size: size,
              label: " Confirm: ",
              controller: _confirmPassword,
              hint: "re-enter password",
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: _obscureConfirm,
              suffix: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            GestureDetector(
              onTap: _loading ? null : _signUp,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Sign Up".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("already have an account? "),
                Text.rich(
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height / 20),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required Size size,
    required String label,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    required List<String> autofillHints,
    required bool obscureText,
    Widget? suffix,
  }) {
    return Container(
      width: size.width / 1.1,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEAEDF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              autofillHints: autofillHints,
              obscureText: obscureText,
              decoration: InputDecoration(
                hint: Text(hint),
                suffixIcon: suffix,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
