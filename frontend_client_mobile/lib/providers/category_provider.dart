import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    print("Calling API");
    if (_isLoading) return;
    await fetchCategories();
    _isLoading = true;
  }

  Future<void> fetchCategories() async {
    print("Calling API");

    try {
      _categories = await _categoryService.getCategories(
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );
    } catch (e) {
      print('Error fetching categories: $e');
    }
    notifyListeners();
  }

  Future<void> searchCategories(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchCategories();
  }

  Future<Category> addCategory(Category category) async {
    try {
      final newCategory = await _categoryService.createCategory(category);
      _categories.add(newCategory);
      notifyListeners();
      return newCategory;
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  Future<Category> updateCategory(Category category) async {
    try {
      final updatedCategory = await _categoryService.updateCategory(
        category.id as int,
        category,
      );
      final index = _categories.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        notifyListeners();
      }
      return updatedCategory;
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  Future<String> uploadCategoryImage(XFile imageFile) async {
    try {
      final multipartFile = await FileUtils.convertXFileToMultipart(imageFile);
      final imageUrl = await _categoryService.uploadCategoryImage(
        multipartFile!,
      );
      return imageUrl;
    } catch (e) {
      print('Error uploading category image: $e');
      rethrow;
    }
  }
}
