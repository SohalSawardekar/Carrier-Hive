class Users {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isLoggedIn = false;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Users.fromMap(Map<String, dynamic> map, String documentId) {
    return Users(
      id: documentId,
      name: map['name'] as String,
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return ({
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    });
  }
}
