import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/services/size_service.dart';

class SizeProvider with ChangeNotifier {
  final SizeService _sizeService = SizeService();
  List<Size> _sizes = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  final int _pageSize = 10;
  String _searchQuery = '';
  bool _hasMore = true;

  List<Size> get sizes => _sizes;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchSizes(refresh: true);
  }

  Future<void> fetchSizes({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _sizes = [];
      _totalPages = 0;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    } else {
      if (_isMoreLoading || !_hasMore && _sizes.isNotEmpty) return;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final pageResponse = await _sizeService.getSizes(
        page: _currentPage,
        size: _pageSize,
      );

      final newSizes = pageResponse.content;
      _totalPages = pageResponse.totalPages;

      if (refresh) {
        _sizes = newSizes;
      } else {
        _sizes.addAll(newSizes);
      }

      _currentPage++;

      if (_currentPage >= _totalPages) {
        _hasMore = false;
      }

      print(
        'Fetched sizes: ${_sizes.length}, Page: $_currentPage/$_totalPages',
      );
    } catch (e) {
      print('Error fetching sizes: $e');
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchSizes(refresh: false);
  }

  Future<void> searchSizes(String query) async {
    if (_searchQuery == query) return;
    _searchQuery = query;
    await fetchSizes(refresh: true);
  }

  Future<void> addSize(Size size) async {
    try {
      final newSize = await _sizeService.createSize(size);
      _sizes.insert(0, newSize);
      notifyListeners();
    } catch (e) {
      print('Error adding size: $e');
      rethrow;
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
      rethrow;
    }
  }

  Future<void> removeSize(int id) async {
    try {
      await _sizeService.deleteSize(id);
      _sizes.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting size: $e');
      rethrow;
    }
  }
}
