import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/models/product_search_result.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/category_api_service.dart';
import 'package:frontend_client_mobile/services/api/product_api_service.dart';

class SearchService {
  SearchService({
    CategoryApiService? categoryApi,
    ProductApiService? productApi,
  }) : _categoryApi = categoryApi ?? ApiClient.getCategoryApiService(),
       _productApi = productApi ?? ApiClient.getProductApiService();

  final CategoryApiService _categoryApi;
  final ProductApiService _productApi;

  Future<List<ProductSearchResult>> searchProducts(
    String keyword, {
    int? categoryId,
  }) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return Future.value(const []);
    if (categoryId != null) {
      return _productApi.searchProductsByNameAndCategory(trimmed, categoryId);
    }
    return _productApi.searchProductsByName(trimmed);
  }

  Future<List<CategorySearchResult>> searchCategories(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return Future.value(const []);
    return _categoryApi.searchCategoriesByName(trimmed);
  }
}
