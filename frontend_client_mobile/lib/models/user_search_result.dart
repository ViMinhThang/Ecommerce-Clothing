class UserSearchResult {
  final int id;
  final String fullName;
  final String? email;

  const UserSearchResult({
    required this.id,
    required this.fullName,
    this.email,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    return UserSearchResult(
      id: idValue is num ? idValue.toInt() : int.tryParse('$idValue') ?? 0,
      fullName: (json['fullName'] ?? '') as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
  };
}
