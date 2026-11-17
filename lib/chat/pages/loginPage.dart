import 'package:firebase_auth/firebase_auth.dart';
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
                Text("forget password? "),
                Text("Register Now")
              ],
            )
          ],
        ),
      ),
    );
  }
}
