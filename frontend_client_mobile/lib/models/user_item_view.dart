class UserItemView {
  final int id;
  final String name;
  final String status;
  final List<String> roles;
  final int totalOrder;
  final double totalPrice;
  final String? email;

  const UserItemView({
    required this.id,
    required this.name,
    required this.status,
    required this.roles,
    required this.totalOrder,
    required this.totalPrice,
    this.email,
  });

  factory UserItemView.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    return UserItemView(
      id: idValue is num ? idValue.toInt() : int.tryParse('$idValue') ?? 0,
      name: (json['name'] ?? '') as String,
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
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'role': roles,
      'totalOrder': totalOrder,
      'totalPrice': totalPrice,
      'email': email,
    };
  }
}
