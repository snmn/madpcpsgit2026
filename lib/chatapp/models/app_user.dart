import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.fcmToken,
  });

  final String uid;
  final String email;
  final Timestamp createdAt;
  final String? fcmToken;

  factory AppUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return AppUser(
      uid: snapshot.id,
      email: (data['email'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?) ?? Timestamp.now(),
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'createdAt': createdAt,
      };
}
