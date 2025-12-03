class UserRequest {
  final String username;
  final String fullName;
  final String password;
  final String confirmPassword;
  final String? email;
  final List<String> roles;
  final DateTime? birthDay;

  const UserRequest({
    required this.username,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    this.email,
    required this.roles,
    this.birthDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
      'roles': roles,
      'birthDay': birthDay != null
          ? '${birthDay!.year.toString().padLeft(4, '0')}-${birthDay!.month.toString().padLeft(2, '0')}-${birthDay!.day.toString().padLeft(2, '0')}'
          : null,
    };
  }

  UserRequest copyWith({
    String? username,
    String? fullName,
    String? password,
    String? confirmPassword,
    String? email,
    List<String>? roles,
    DateTime? birthDay,
  }) {
    return UserRequest(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      birthDay: birthDay ?? this.birthDay,
    );
  }
}
