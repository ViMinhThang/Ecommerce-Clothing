// định nghĩa item dùng để hiển thị cũng như là response sau khi gọi request
class CatalogItemViewModel {
  final String title;
  final String imageUrl;
  final bool fullWidth;

  const CatalogItemViewModel({
    required this.title,
    required this.imageUrl,
    this.fullWidth = false,
  });
}
