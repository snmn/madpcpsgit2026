import 'package:demopcpsseca/chatapp/pages/login.dart';
import 'package:demopcpsseca/pages/dashboard.dart';
import 'package:demopcpsseca/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chatapp/models/app_user.dart';
import 'chatapp/services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _firestoreService = FirestoreService();
  String? _ensuredUid;

  Future<void> _ensureUser(User user) async {
    if (_ensuredUid == user.uid) return;
    _ensuredUid = user.uid;
    final now = DateTime.now();
    final displayName = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email?.split('@').first ?? 'User');

    try {
      await _firestoreService.createOrUpdateUser(
        AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName,
          photoUrl: user.photoURL,
          createdAt: now,
          lastSeen: now,
        ),
      );
    } on FirebaseException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to update your profile in Firestore.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Unable to check your sign-in status.')),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _ensureUser(user);
          });
          return const dashboard();
        }
        return const LoginPage();
      },
    );
  }
}
