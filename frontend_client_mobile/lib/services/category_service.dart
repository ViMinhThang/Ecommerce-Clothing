import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/category.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/category_api_service.dart';

class CategoryService {
  final CategoryApiService _apiService = ApiClient.getCategoryApiService();

  Future<List<Category>> getCategories({String? name}) async {
    return await _apiService.getCategories(name);
  }

  Future<Category> createCategory(Category category) async {
    return await _apiService.createCategory(category);
  }

  Future<Category> updateCategory(int id, Category category) async {
    return await _apiService.updateCategory(id, category);
  }

  Future<void> deleteCategory(int id) async {
    return await _apiService.deleteCategory(id);
  }

  Future<String> uploadCategoryImage(MultipartFile imageFile) async {
    return await _apiService.uploadCategoryImage(imageFile);
  }
}
