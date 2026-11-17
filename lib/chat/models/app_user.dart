class AppUser {
  final String uid;
  final String name;
  final String email;

  const AppUser({required this.uid, required this.name, required this.email});

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    final name = (map['name'] as String?)?.trim() ?? '';
    final email = (map['email'] as String?)?.trim() ?? '';
    return AppUser(
      uid: uid,
      name: name.isEmpty ? email.split('@').first : name,
      email: email,
    );
  }
}