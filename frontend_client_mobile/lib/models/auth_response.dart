import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final String type;
  final int id;
  final String username;
  final String email;
  final String fullName;
  final List<String> roles;

  AuthResponse({
    required this.token,
    this.type = 'Bearer',
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
