import 'package:json_annotation/json_annotation.dart';

part 'product_view.g.dart';

@JsonSerializable()
class ProductView {
  final int id; // Java long -> Dart int
  final String name;
  final String imageUrl;
  final double basePrice;
  final double salePrice;
  final String description;

  ProductView({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.basePrice,
    required this.salePrice,
    required this.description,
  });

  // Factory constructor để tạo object từ JSON (Map)
  factory ProductView.fromJson(Map<String, dynamic> json) {
    return ProductView(
      // Java 'long' tương đương Dart 'int'
      id: json['id'] ?? 0,

      name: json['name'] ?? 'No Name',

      // Xử lý null cho ảnh để tránh lỗi UI
      imageUrl: json['imageUrl'] ?? '',

      // QUAN TRỌNG: JSON đôi khi trả về số nguyên (100) thay vì số thực (100.0)
      // Dùng (json['x'] as num).toDouble() để an toàn nhất
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,

      description: json['description'] ?? '',
    );
  }

  // Hàm chuyển ngược lại thành JSON (nếu cần gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'basePrice': basePrice,
      'salePrice': salePrice,
      'description': description,
    };
  }

  // --- Helper Getters (Tùy chọn: Giúp UI sạch hơn) ---

  // Kiểm tra xem có đang giảm giá không
  bool get isOnSale => salePrice > 0 && salePrice < basePrice;

  // Lấy giá hiển thị (Nếu sale thì lấy salePrice, không thì basePrice)
  double get displayPrice => isOnSale ? salePrice : basePrice;

  // Tính phần trăm giảm giá
  String get discountPercent {
    if (!isOnSale) return '';
    final percent = ((basePrice - salePrice) / basePrice) * 100;
    return '-${percent.toStringAsFixed(0)}%';
  }
}
