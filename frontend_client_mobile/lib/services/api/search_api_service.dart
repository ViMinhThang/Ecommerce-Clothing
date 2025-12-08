import 'package:dio/dio.dart';

/// Low-level API layer for search endpoints.
class SearchApiService {
  SearchApiService(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> searchProducts(String keyword, {int? categoryId}) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        Response(
          requestOptions: RequestOptions(path: ''),
          data: const [],
        ),
      );
    }

    final path = categoryId == null
        ? '/api/products/searchByName'
        : '/api/products/searchByNameAndCategory';
    final query = categoryId == null
        ? {'name': trimmed}
        : {'name': trimmed, 'categoryId': categoryId};

    return _dio.get(path, queryParameters: query);
  }

  Future<Response<dynamic>> searchCategories(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        Response(
          requestOptions: RequestOptions(path: ''),
          data: const [],
        ),
      );
    }

    return _dio.get(
      '/api/categories/searchByName',
      queryParameters: {'name': trimmed},
    );
  }
}
