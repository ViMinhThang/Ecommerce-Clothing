import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/models/product_search_result.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/search_api_service.dart';

class SearchService {
  SearchService({SearchApiService? apiService})
    : _apiService = apiService ?? ApiClient.getSearchApiService();

  final SearchApiService _apiService;

  Future<List<ProductSearchResult>> searchProducts(
    String keyword, {
    int? categoryId,
  }) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return const [];
    final res = await _apiService.searchProducts(
      trimmed,
      categoryId: categoryId,
    );
    final data = _coerceList(res.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductSearchResult.fromJson)
        .toList();
  }

  Future<List<CategorySearchResult>> searchCategories(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return const [];
    final res = await _apiService.searchCategories(trimmed);
    final data = _coerceList(res.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(CategorySearchResult.fromJson)
        .toList();
  }

  List<dynamic> _coerceList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      final dynamic inner = raw['data'] ?? raw['content'] ?? raw['items'];
      if (inner is List) return inner;
    }
    return const [];
  }
}
