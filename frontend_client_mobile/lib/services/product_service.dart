import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/product_api_service.dart';

class ProductService {
  final ProductApiService _apiService = ApiClient.getProductApiService();

  Future<PageResponse<Product>> getProducts({
    String? name,
    int page = 0,
    int size = 10,
  }) async {
    final response = await _apiService.getProducts(name, page, size);
    return response.data;
  }

  Future<Product> createProduct(Product product, {MultipartFile? image}) async {
    final variantsJson = json.encode(
      product.variants.map((v) => v.toJson()).toList(),
    );
    return await _apiService.createProduct(
      product.name,
      product.description,
      product.category.id!,
      variantsJson,
      image,
    );
  }

  Future<Product> updateProduct(
    int id,
    Product product, {
    MultipartFile? image,
  }) async {
    final variantsJson = json.encode(
      product.variants.map((v) => v.toJson()).toList(),
    );

    final response = await _apiService.updateProduct(
      id,
      product.name,
      product.description,
      product.category.id!,
      variantsJson,
      image,
    );
    return response;
  }

  Future<void> deleteProduct(int id) async {
    await _apiService.deleteProduct(id);
  }

  Future<PageResponse<ProductView>> getProductsByCategory(
    int categoryId,
    int page,
    int size,
  ) async {
    final response = await _apiService.getProductsByCategory(
      categoryId,
      page,
      size,
    );
    return response.data;
  }

  Future<PageResponse<ProductView>> filterProduct(int categoryId) async {
    return null!;
  }
}
