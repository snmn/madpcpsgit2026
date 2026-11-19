import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSigningIn = false;
  bool _isSigningUp = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isSigningIn || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSigningIn = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_messageForAuthError(error.code))));
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  Future<void> _signUp() async {
    if (_isSigningIn || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSigningIn = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      await credential.user?.updateDisplayName(
        _displayNameController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_messageForAuthError(error.code))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isSigningUp = !_isSigningUp;
      _formKey.currentState?.reset();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  String _messageForAuthError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Email or password is incorrect.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support for help.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'Unable to connect. Check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Email and password sign-in is not enabled for this app.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Choose a stronger password with at least 6 characters.';
      default:
        return _isSigningUp
            ? 'Unable to create your account. Please try again.'
            : 'Unable to sign in. Please try again.';
    }
  }

  String? _validateDisplayName(String? value) {
    if (_isSigningUp && (value == null || value.trim().isEmpty)) {
      return 'Enter your name.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    if (_isSigningUp && value.length < 6) {
      return 'Use at least 6 characters.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_isSigningUp && (value == null || value.isEmpty)) {
      return 'Confirm your password.';
    }
    if (_isSigningUp && value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    SizedBox(
                      height: size.height / 1.7,
                      width: size.width,
                      child: Image.network(
                        'https://i.pinimg.com/1200x/b7/ee/20/b7ee20b6778a5603d57c7153646d2809.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(color: Colors.black12),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      width: size.width,
                      child: const Center(
                        child: Text(
                          'CONVO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isSigningUp)
                  _inputContainer(
                    width: size.width / 1.1,
                    label: 'Name',
                    child: TextFormField(
                      controller: _displayNameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: _validateDisplayName,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                _inputContainer(
                  width: size.width / 1.1,
                  label: 'Email',
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email here',
                    ),
                  ),
                ),
                _inputContainer(
                  width: size.width / 1.1,
                  label: 'Password',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: _isSigningUp
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    validator: _validatePassword,
                    onFieldSubmitted: _isSigningUp ? null : (_) => _signIn(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your password here',
                    ),
                  ),
                ),
                if (_isSigningUp)
                  _inputContainer(
                    width: size.width / 1.1,
                    label: 'Confirm',
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: _validateConfirmPassword,
                      onFieldSubmitted: (_) => _signUp(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm your password',
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  child: ElevatedButton(
                    onPressed: _isSigningIn
                        ? null
                        : (_isSigningUp ? _signUp : _signIn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                    ),
                    child: _isSigningIn
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isSigningUp ? 'CREATE ACCOUNT' : 'LOGIN'),
                  ),
                ),
                TextButton(
                  onPressed: _isSigningIn ? null : _toggleAuthMode,
                  child: Text(
                    _isSigningUp
                        ? 'Already have an account? Log in'
                        : 'Create an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputContainer({
    required double width,
    required String label,
    required Widget child,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text('$label: '),
          Expanded(child: child),
        ],
      ),
    );
  }
}
