import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../pages/chat.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialized = false;

  Future<void> init(
    GlobalKey<NavigatorState> navigatorKey, {
    RemoteMessage? initialMessage,
  }) async {
    _navigatorKey = navigatorKey;
    if (_initialized) return;
    _initialized = true;

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_openMessage);

    FirebaseMessaging.instance.onRegistered.listen((token) {
      _writeToken(token).catchError((_) {});
    });

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) return;
      FirebaseMessaging.instance.register().catchError((_) {});
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseMessaging.instance.register().catchError((_) {});
    }

    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openMessage(initialMessage);
      });
    }
  }

  Future<void> _writeToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      <String, dynamic>{'fcmToken': token},
      SetOptions(merge: true),
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final text = message.notification?.body ??
        message.data['text'] as String? ??
        'You have a new chat message';
    final context = _navigatorKey?.currentContext;
    if (context == null) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _openMessage(RemoteMessage message) async {
    final senderId = message.data['senderId'] as String?;
    if (senderId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();
      if (!snapshot.exists) return;
      final otherUser = AppUser.fromSnapshot(snapshot);
      final navigator = _navigatorKey?.currentState;
      if (navigator == null) return;
      navigator.push(
        MaterialPageRoute<void>(
          builder: (context) => ChatPage(otherUser: otherUser),
        ),
      );
    } catch (_) {
      // Invalid or unavailable notification data should not crash the app.
    }
  }

  Future<void> sendPushNotification({
    required String recipientToken,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFunctions.instance
        .httpsCallable('sendPushNotification')
        .call(<String, dynamic>{
      'token': recipientToken,
      'title': title,
      'body': body,
      'data': data.map((key, value) => MapEntry(key, value.toString())),
    });
  }
}
