class RoleView {
  final int id;
  final String name;

  const RoleView({required this.id, required this.name});

  factory RoleView.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    return RoleView(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }
}
