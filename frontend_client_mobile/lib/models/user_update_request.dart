class UserUpdateRequest {
  final String fullName;
  final String? email;
  final DateTime? birthDay;

  const UserUpdateRequest({required this.fullName, this.email, this.birthDay});

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    final rawBirthDay = json['birthDay'];
    DateTime? parsedBirthDay;
    if (rawBirthDay != null && '$rawBirthDay'.isNotEmpty) {
      parsedBirthDay = DateTime.tryParse('$rawBirthDay');
    }

    return UserUpdateRequest(
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      email: json['email'] as String?,
      birthDay: parsedBirthDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'birthDay': birthDay != null
          ? '${birthDay!.year.toString().padLeft(4, "0")}-${birthDay!.month.toString().padLeft(2, "0")}-${birthDay!.day.toString().padLeft(2, "0")}'
          : null,
    };
  }
}
