import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final List<String>? roles;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.roles,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
