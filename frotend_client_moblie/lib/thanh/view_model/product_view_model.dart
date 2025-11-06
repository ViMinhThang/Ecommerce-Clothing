// định nghĩa item dùng để hiển thị cũng như là response sau khi gọi request
class ProductViewModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ProductViewModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
