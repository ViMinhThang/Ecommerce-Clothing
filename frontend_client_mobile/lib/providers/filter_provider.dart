import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/filter_service.dart';

class FilterProvider with ChangeNotifier {
  final FilterService _FilterService = FilterService();
  double _minPrice = 0;
  double _maxPrice = 0;
  List<String> _sizes = [];
  List<String> _seasons = [];
  List<String> _materials = [];
  List<String> _colors = [];
  bool _isSale = false;
  int _count = 0;
  bool _isLoading = false;
  // --- Getters ---

  double get minPrice => _minPrice;

  double get maxPrice => _maxPrice;

  List<String> get sizes => _sizes;

  List<String> get seasons => _seasons;

  List<String> get materials => _materials;

  List<String> get colors => _colors;

  bool get isSale => _isSale;

  bool get isLoading => _isLoading;
  int get count => _count;
  FilterProvider() {
    print('🧩 FilterProvider created at ${DateTime.now()}');
  }
  Future<void> initialize(int categoryId) async {
    if (_isLoading) return;
    await fetchFilters(categoryId);
    _isLoading = true;
  }

  Future<void> fetchFilters(int categoryId) async {
    try {
      var _filters = await _FilterService.getFilterAttributes(categoryId);
      _minPrice = _filters.minPrice;
      _maxPrice = _filters.maxPrice;
      _sizes = _filters.sizes;
      _seasons = _filters.seasons;
      _materials = _filters.materials;
      _colors = _filters.colors;
    } catch (e) {
      // Handle error
      print('Error fetching Filters: $e');
    }
    notifyListeners();
  }

  Future<void> countProductAvailable(Map<String, dynamic> filters, int categoryId) async {
    try {
      _count = await _FilterService.countProductAvailable(filters, categoryId);
    } catch (e) {
      // Handle error
      print('Error counting Products: $e');
    }
    notifyListeners();
  }

  Future<void> filter(Map<String, dynamic> filters, int categoryId) async {
    try {
      var productViews = await _FilterService.filters(filters, categoryId);
    } catch (e) {
      // Handle error
      print('Error fetching Filters: $e');
    }
    notifyListeners();
  }
}
