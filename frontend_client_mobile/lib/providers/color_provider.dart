import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/services/color_service.dart';

class ColorProvider with ChangeNotifier {
  final ColorService _colorService = ColorService();
  List<Color> _colors = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  final int _pageSize = 10;
  String _searchQuery = '';
  bool _hasMore = true;

  List<Color> get colors => _colors;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchColors(refresh: true);
  }

  Future<void> fetchColors({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _colors = [];
      _totalPages = 0;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    } else {
      if (_isMoreLoading || !_hasMore && _colors.isNotEmpty) return;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final pageResponse = await _colorService.getColors(
        page: _currentPage,
        size: _pageSize,
      );

      final newColors = pageResponse.content;
      _totalPages = pageResponse.totalPages;

      if (refresh) {
        _colors = newColors;
      } else {
        _colors.addAll(newColors);
      }

      _currentPage++;

      if (_currentPage >= _totalPages) {
        _hasMore = false;
      }

      print(
        'Fetched colors: ${_colors.length}, Page: $_currentPage/$_totalPages',
      );
    } catch (e) {
      print('Error fetching colors: $e');
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchColors(refresh: false);
  }

  Future<void> searchColors(String query) async {
    if (_searchQuery == query) return;
    _searchQuery = query;
    await fetchColors(refresh: true);
  }

  Future<void> addColor(Color color) async {
    try {
      final newColor = await _colorService.createColor(color);
      _colors.insert(0, newColor);
      notifyListeners();
    } catch (e) {
      print('Error adding color: $e');
      rethrow;
    }
  }

  Future<void> updateColor(Color color) async {
    try {
      final updatedColor = await _colorService.updateColor(
        color.id as int,
        color,
      );
      final index = _colors.indexWhere((c) => c.id == updatedColor.id);
      if (index != -1) {
        _colors[index] = updatedColor;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating color: $e');
      rethrow;
    }
  }

  Future<void> removeColor(int id) async {
    try {
      await _colorService.deleteColor(id);
      _colors.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting color: $e');
      rethrow;
    }
  }
}
