class UserDetailView {
  final int? id;
  final String name;
  final String? email;
  final DateTime? birthDay;
  final String status;
  final List<String> roles;
  final int totalOrder;
  final double totalPrice;

  const UserDetailView({
    this.id,
    required this.name,
    this.email,
    this.birthDay,
    required this.status,
    required this.roles,
    required this.totalOrder,
    required this.totalPrice,
  });

  factory UserDetailView.fromJson(Map<String, dynamic> json) {
    final birthDayRaw = json['birthDay'];
    DateTime? birthDay;
    if (birthDayRaw != null && '$birthDayRaw'.isNotEmpty) {
      birthDay = DateTime.tryParse('$birthDayRaw');
    }

    return UserDetailView(
      id: json['id'] is num ? (json['id'] as num).toInt() : json['id'] as int?,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String?,
      birthDay: birthDay,
      status: (json['status'] ?? '') as String,
      roles:
          (json['role'] as List?)
              ?.map((role) => role?.toString() ?? '')
              .where((value) => value.isNotEmpty)
              .toList() ??
          const [],
      totalOrder: json['totalOrder'] is num
          ? (json['totalOrder'] as num).toInt()
          : int.tryParse('${json['totalOrder']}') ?? 0,
      totalPrice: json['totalPrice'] is num
          ? (json['totalPrice'] as num).toDouble()
          : double.tryParse('${json['totalPrice']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthDay': birthDay?.toIso8601String(),
      'status': status,
      'role': roles,
      'totalOrder': totalOrder,
      'totalPrice': totalPrice,
    };
  }
}
