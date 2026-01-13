class UserUpdateRequest {
  final String? username;
  final String fullName;
  final String? email;
  final String? phone;
  final DateTime? birthDay;

  const UserUpdateRequest({
    this.username,
    required this.fullName,
    this.email,
    this.phone,
    this.birthDay,
  });

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    final rawBirthDay = json['birthDay'];
    DateTime? parsedBirthDay;
    if (rawBirthDay != null && '$rawBirthDay'.isNotEmpty) {
      parsedBirthDay = DateTime.tryParse('$rawBirthDay');
    }

    return UserUpdateRequest(
      username: json['username'] as String?,
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      birthDay: parsedBirthDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'birthDay': birthDay != null
          ? '${birthDay!.year.toString().padLeft(4, "0")}-${birthDay!.month.toString().padLeft(2, "0")}-${birthDay!.day.toString().padLeft(2, "0")}'
          : null,
    };
  }
}
