class Akun {
  final int id;
  final String username;
  final String email;
  final String? userRole;

  Akun({
    required this.id,
    required this.username,
    required this.email,
    this.userRole,
  });

  factory Akun.fromJson(Map<String, dynamic> json) {
    return Akun(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      userRole: json['user_role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'user_role': userRole};
  }
}
