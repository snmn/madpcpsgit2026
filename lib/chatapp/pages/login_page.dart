import 'package:demopcpsseca/pages/dashboard.dart';
import 'package:demopcpsseca/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _showSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const dashboard()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to create account. Please try again."),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (context) => const dashboard()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: size.height / 1.6,
                  width: size.width,
                  child: Image.network(
                    fit: BoxFit.cover,
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7TWU1OpSO_J38hCm2Zp1duR-khopG3-wyLqOHCaN92Q&s=10"),
                ),
                Positioned(
                  bottom: -20,
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Kurafy", style: TextStyle(
                          color: Color(0xff03518D), fontSize: 80,
                          fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.black12,
                borderRadius: BorderRadius.circular(20)
              ),
              width: size.width / 1.2,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hint: Text("Enter your email here"),
                  border: InputBorder.none
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: size.width / 1.2,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                    hint: Text("Enter your password here"),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    )),
              ),
            ),
            if (_showSignUp)
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: size.width / 1.2,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    hintText: "Confirm your password",
                    border: InputBorder.none,
                  ),
                ),
              ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),

            GestureDetector(
              onTap: _isLoading
                  ? null
                  : _showSignUp
                      ? _signUp
                      : _signIn,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple
                ),
                padding: EdgeInsets.only(left: 15, right: 15, top: 8,
                bottom: 8),
                child:
                Text(
                  _isLoading
                      ? " Loading "
                      : (_showSignUp ? " Sign up " : " Login ").toUpperCase(),
                style: TextStyle(color: Colors.white),),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot password?"),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => setState(() {
                        _showSignUp = !_showSignUp;
                        _confirmPasswordController.clear();
                      }),
              child: Text(_showSignUp ? "Back to login" : "Sign up"),
            ),

          ],
        ),
      ),
    );
  }
}
