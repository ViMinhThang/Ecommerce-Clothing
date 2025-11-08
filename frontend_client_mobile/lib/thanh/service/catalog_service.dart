import 'package:frontend_client_mobile/thanh/view_model/catalog_card_view_model.dart';

// class chuyên xử lý việc gọi api và trả về response hoặc lỗi nếu có cho CatalogItemViewModel
class CatalogService {
  // Tiêm danh sách product view model
  Future<List<CatalogItemViewModel>> fetchCatalogCards() async {
    //await Future.delayed(Duration(seconds: 1));
    final catalogCards = <CatalogItemViewModel>[
      CatalogItemViewModel(
        title: 'Dresses',
        imageUrl: 'https://picsum.photos/seed/dresses/600/800',
      ),
      CatalogItemViewModel(
        title: 'Jackets & Blazers',
        imageUrl: 'https://picsum.photos/seed/jackets/600/800',
      ),
      CatalogItemViewModel(
        title: 'Coats',
        imageUrl: 'https://picsum.photos/seed/coats/600/800',
      ),
      CatalogItemViewModel(
        title: 'Shirts',
        imageUrl: 'https://picsum.photos/seed/shirts/600/800',
      ),
      CatalogItemViewModel(
        title: 'Lingerie & Nightwear',
        imageUrl: 'https://picsum.photos/seed/lingerie/800/600',
      ),
      CatalogItemViewModel(
        title: 'Collections',
        imageUrl: 'https://picsum.photos/seed/collections/800/600',
      ),
      CatalogItemViewModel(
        title: 'New products',
        imageUrl: 'https://picsum.photos/seed/newproducts/900/600',
        fullWidth: true,
      ),
    ];
    return catalogCards;
  }
}
