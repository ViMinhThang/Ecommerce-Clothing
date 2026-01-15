import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/page_response.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/services/filter_service.dart';
import 'package:retrofit/retrofit.dart';

class FilterProvider with ChangeNotifier {
  final FilterService _service;

  FilterProvider() : _service = FilterService();

  // ----- Raw options từ API (bộ tham số trần/sàn) -----
  double _minPrice = 0;
  double _maxPrice = 0;
  List<String> _sizes = [];
  List<String> _seasons = [];
  List<String> _materials = [];
  List<String> _colors = [];

  // ----- State lọc hiện tại (do user chọn) -----
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 0;
  bool _selectedOnSale = false;

  final Set<String> _selectedSizes = {};
  final Set<String> _selectedSeasons = {};
  final Set<String> _selectedMaterials = {};
  final Set<int> _selectedColorIdx = {};

  // ----- Trạng thái hệ thống -----
  bool _isLoading = false; // đang load metadata filter
  bool _isCounting = false; // đang gọi API đếm matched
  bool _isFiltering = false; // đang load trang đầu
  bool _isFetchingMore = false; // đang load trang tiếp theo
  int _matchedCount = 0;
  int _categoryId = 0;

  // ----- Phân trang -----
  int _page = 0; // index page hiện tại (0-based như PageResponse.number)
  final int _pageSize = 10; // size mặc định
  bool _hasMore = true; // còn page tiếp không

  // ----- Kết quả product theo filter -----
  List<ProductView> _productViews = [];

  // ----- Getters -----
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  List<String> get sizes => _sizes;
  List<String> get seasons => _seasons;
  List<String> get materials => _materials;
  List<String> get colors => _colors;

  double get selectedMinPrice => _selectedMinPrice;
  double get selectedMaxPrice => _selectedMaxPrice;
  bool get selectedOnSale => _selectedOnSale;
  Set<String> get selectedSizes => _selectedSizes;
  Set<String> get selectedSeasons => _selectedSeasons;
  Set<String> get selectedMaterials => _selectedMaterials;
  Set<int> get selectedColorIdx => _selectedColorIdx;

  bool get isLoading => _isLoading;
  bool get isCounting => _isCounting;
  bool get isFiltering => _isFiltering;
  bool get isFetchingMore => _isFetchingMore;
  int get matchedCount => _matchedCount;
  int get categoryId => _categoryId;

  int get page => _page;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;

  List<ProductView> get productViews => _productViews;

  /// Map filter hiện tại (không có page/pageSize)
  Map<String, dynamic> get currentFilterMap => _buildFiltersMap();

  /// Có filter nào đang active không? (so với default)
  bool get hasActiveFilter {
    final isPriceChanged =
        _selectedMinPrice != _minPrice || _selectedMaxPrice != _maxPrice;
    final hasSizes =
        _selectedSizes.length != _sizes.length; // nếu default là chọn hết
    final hasOthers =
        _selectedOnSale ||
        _selectedSeasons.isNotEmpty ||
        _selectedMaterials.isNotEmpty ||
        _selectedColorIdx.isNotEmpty;

    return isPriceChanged || hasSizes || hasOthers;
  }

  // =========================================================
  // INIT
  // =========================================================

  Future<void> initialize(int categoryId) async {
    if (_isLoading && _categoryId == categoryId) return;

    _isLoading = true;
    _categoryId = categoryId;
    notifyListeners();

    try {
      final attrs = await _service.getFilterAttributes(categoryId);
      _minPrice = attrs.minPrice;
      _maxPrice = attrs.maxPrice;
      _sizes = attrs.sizes;
      _seasons = attrs.seasons;
      _materials = attrs.materials;
      _colors = attrs.colors;

      // Thiết lập default cho lựa chọn
      _selectedMinPrice = _minPrice;
      _selectedMaxPrice = _maxPrice;
      _selectedOnSale = false;

      _selectedSizes
        ..clear()
        ..addAll(_sizes); // default: chọn hết size (tuỳ logic bạn)

      _selectedSeasons.clear();
      _selectedMaterials.clear();
      _selectedColorIdx.clear();

      // Đếm matched
      final filters = _buildFiltersMap();
      _matchedCount = await _service.countProductAvailable(filters);

      // Reset phân trang
      _page = 0;
      _hasMore = true;

      // Load trang đầu (category only, vì filter default)
      await refreshProducts();
    } catch (e, st) {
      debugPrint('Error initialize filters: $e\n$st');
      _matchedCount = 0;
      _productViews = [];
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // FILTER + PHÂN TRANG
  // =========================================================

  /// Gọi trang đầu tiên theo filter hiện tại (reset list)
  Future<void> refreshProducts() async {
    _isFiltering = true;
    notifyListeners();

    try {
      _page = 0;
      _hasMore = true;

      final baseFilters = _buildFiltersMap();
      final request = {
        ...baseFilters,
        'page':
            _page, // nếu backend dùng 1-based: dùng 0 hoặc 1, xem chú ý ở dưới
        'size': _pageSize,
      };

      final HttpResponse<PageResponse<ProductView>> response = await _service
          .filters(request);

      final pageData = response.data;
      _productViews = pageData.content;

      // Với PageResponse:
      // - number: index page hiện tại
      // - totalPages: tổng số page
      // Còn nữa nếu number < totalPages - 1
      _hasMore = pageData.number < pageData.totalPages - 1;
      _page = pageData.number;
    } catch (e, st) {
      debugPrint('Error refreshProducts: $e\n$st');
      _productViews = [];
      _hasMore = false;
    } finally {
      _isFiltering = false;
      notifyListeners();
    }
  }

  /// Load trang tiếp theo (append)
  Future<void> loadMore() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = _page + 1;

      final baseFilters = _buildFiltersMap();
      final request = {
        ...baseFilters,
        'page': nextPage, // nếu backend 1-based: dùng nextPage + 1
        'size': _pageSize,
      };

      final HttpResponse<PageResponse<ProductView>> response = await _service
          .filters(request);

      final pageData = response.data;
      _productViews.addAll(pageData.content);

      _hasMore = pageData.number < pageData.totalPages - 1;
      _page = pageData.number;
    } catch (e, st) {
      debugPrint('Error loadMore: $e\n$st');
      // nếu lỗi có thể giữ nguyên _page, đã không set lại ở trên
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ĐẾM MATCHED
  // =========================================================

  void callUpdateMatchedCount() {
    _updateMatchedCount();
  }

  Future<void> _updateMatchedCount() async {
    if (_categoryId == 0) return;
    _isCounting = true;
    notifyListeners();
    try {
      final filters = _buildFiltersMap();
      await countProductAvailable(filters);
    } finally {
      _isCounting = false;
      notifyListeners();
    }
  }

  Future<void> countProductAvailable(Map<String, dynamic> filters) async {
    try {
      _matchedCount = await _service.countProductAvailable(filters);
    } catch (e) {
      debugPrint('Error counting Products: $e');
    }
    notifyListeners();
  }

  // =========================================================
  // BUILD FILTER MAP
  // =========================================================

  Map<String, dynamic> _buildFiltersMap() {
    return {
      'categoryId': _categoryId,
      'minPrice': _selectedMinPrice,
      'maxPrice': _selectedMaxPrice,
      'onSale': _selectedOnSale,
      'sizes': _selectedSizes.toList(),
      'seasons': _selectedSeasons.toList(),
      'materials': _selectedMaterials.toList(),
      'colors': _selectedColorIdx.map((i) => _colors[i]).toList(),
      // KHÔNG để page/size ở đây, chỉ add trong refreshProducts/loadMore
    };
  }

  // =========================================================
  // CÁC HÀM SET FILTER
  // =========================================================

  void setSelectedPriceRange(double min, double max) {
    _selectedMinPrice = min;
    _selectedMaxPrice = max;
    _isCounting = true;
    notifyListeners();
  }

  void toggleOnSale(bool value) {
    _selectedOnSale = value;
    notifyListeners();
    _updateMatchedCount();
  }

  void toggleSize(String size) {
    if (_selectedSizes.contains(size)) {
      _selectedSizes.remove(size);
    } else {
      _selectedSizes.add(size);
    }
    notifyListeners();
    _updateMatchedCount();
  }

  void toggleSeason(String season) {
    if (_selectedSeasons.contains(season)) {
      _selectedSeasons.remove(season);
    } else {
      _selectedSeasons.add(season);
    }
    notifyListeners();
    _updateMatchedCount();
  }

  void toggleMaterial(String material) {
    if (_selectedMaterials.contains(material)) {
      _selectedMaterials.remove(material);
    } else {
      _selectedMaterials.add(material);
    }
    notifyListeners();
    _updateMatchedCount();
  }

  void toggleColorIndex(int idx) {
    if (_selectedColorIdx.contains(idx)) {
      _selectedColorIdx.remove(idx);
    } else {
      _selectedColorIdx.add(idx);
    }
    notifyListeners();
    _updateMatchedCount();
  }

  void resetSizesSelection() {
    _selectedSizes
      ..clear()
      ..addAll(_sizes);
    notifyListeners();
    _updateMatchedCount();
  }

  void resetMaterialsSelection() {
    _selectedMaterials.clear();
    notifyListeners();
    _updateMatchedCount();
  }

  void resetColorsSelection() {
    _selectedColorIdx.clear();
    notifyListeners();
    _updateMatchedCount();
  }

  void resetFilters() {
    _selectedMinPrice = _minPrice;
    _selectedMaxPrice = _maxPrice;
    _selectedOnSale = false;
    _selectedSizes
      ..clear()
      ..addAll(_sizes);
    _selectedSeasons.clear();
    _selectedMaterials.clear();
    _selectedColorIdx.clear();
    notifyListeners();
    _updateMatchedCount();
  }
}
