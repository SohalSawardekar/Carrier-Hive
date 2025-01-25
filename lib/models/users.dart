class Users {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory Users.fromMap(Map<String, dynamic> map, String documentId) {
    return Users(
      id: documentId,
      name: map['name'] as String,
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return ({
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
  }
}
