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

