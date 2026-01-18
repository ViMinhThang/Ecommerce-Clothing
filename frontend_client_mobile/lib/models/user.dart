import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  @JsonKey(includeToJson: false)
  final String? password;
  final String email;
  final String? avatarUrl;
  final String? fullName;
  final String? phone;

  User({
    required this.id,
    required this.username,
    this.password,
    required this.email,
    this.avatarUrl,
    this.fullName,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? email,
    String? avatarUrl,
    String? fullName,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }
}

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
