import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/services/size_service.dart';

class SizeProvider with ChangeNotifier {
  final SizeService _sizeService = SizeService();
  List<Size> _sizes = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Size> get sizes => _sizes;
  bool get isLoading => _isLoading;
  SizeProvider() {
    print('🧩 SizeProvider created at ${DateTime.now()}');
  }
  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchSizes();
    _isLoading = true;
  }

  Future<void> fetchSizes() async {
    try {
      _sizes = await _sizeService.getSizes(
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );
    } catch (e) {
      // Handle error
      print('Error fetching sizes: $e');
    }
    notifyListeners();
  }

  Future<void> searchSizes(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchSizes();
  }

  // In your SizeProvider
  Future<void> addSize(Size size) async {
    print('API call started at: ${DateTime.now()}'); // Debug log
    try {
      final newSize = await _sizeService.createSize(size);
      print('API call completed: ${newSize.id}'); // Debug log
      _sizes.add(newSize);
      notifyListeners();
    } catch (e) {
      print('Error adding size: $e');
    }
  }

  Future<void> updateSize(Size size) async {
    try {
      final updatedSize = await _sizeService.updateSize(size.id as int, size);
      final index = _sizes.indexWhere((s) => s.id == updatedSize.id);
      if (index != -1) {
        _sizes[index] = updatedSize;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating size: $e');
    }
  }

  Future<void> removeSize(int id) async {
    try {
      await _sizeService.deleteSize(id);
      _sizes.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting size: $e');
    }
  }
}
