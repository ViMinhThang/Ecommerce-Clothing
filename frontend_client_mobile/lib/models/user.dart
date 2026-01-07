class UserDetail {
  final int? id;
  final String username;
  final String fullName;
  final String? email;
  final String? birthDay; // ISO date string

  UserDetail({
    this.id,
    required this.username,
    required this.fullName,
    this.email,
    this.birthDay,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json['id'] != null ? (json['id'] as num).toInt() : null,
    username: json['username'] ?? '',
    fullName: json['fullName'] ?? json['name'] ?? '',
    email: json['email'],
    birthDay: json['birthDay']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'username': username,
    'fullName': fullName,
    'email': email,
    'birthDay': birthDay,
  };
}
