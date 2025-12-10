import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<ProductView> _productViews = [];

  bool _isLoading = false; // Loading to (giữa màn hình)
  bool _isMoreLoading = false; // Loading nhỏ (dưới đáy)
  int _currentPage = 0;
  int _totalPages = 0;
  final int _pageSize = 10;
  String _searchQuery = '';

  bool _hasMore = true;

  int _currentCategoryId = 0;

  // --- GETTERS ---
  List<Product> get products => _products;
  List<ProductView> get productViews => _productViews;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;

  // SỬA GETTER NÀY: Trả về biến _hasMore thay vì tính toán
  bool get hasMore => _hasMore;
  Future<void> initialize() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    await fetchProducts(
      refresh: true,
    ); // hoặc fetchProducts(), nhưng để refresh=true cho sạch
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _products = [];
      _totalPages = 0;
      _isLoading = true;
      _isMoreLoading = false;
      _hasMore = true;
      notifyListeners();
    } else {
      // Nếu đang load-more hoặc hết hàng -> nghỉ
      if (_isMoreLoading || (!_hasMore && _products.isNotEmpty)) return;

      if (_products.isEmpty) {
        // Lần load đầu (initial) nhưng không refresh
        _isLoading = true;
        _isMoreLoading = false;
        notifyListeners();
      } else {
        // Load-more thật sự
        _isMoreLoading = true;
        _isLoading = false;
        notifyListeners();
      }
    }

    try {
      final response = await _productService.getProducts(
        name: _searchQuery,
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh || _products.isEmpty) {
        _products = response.content;
      } else {
        _products.addAll(response.content);
      }

      _totalPages = response.totalPages;
      _currentPage++;

      if (response.content.length < _pageSize) {
        _hasMore = false;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchProducts(refresh: false);
  }

  Future<void> searchProducts(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchProducts(refresh: true);
  }

  Future<void> addProduct(Product product, {XFile? image}) async {
    try {
      final newProduct = await _productService.createProduct(
        product,
        image: await FileUtils.convertXFileToMultipart(image),
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (e, stack) {
      // Handle error
      print(e);
      print(stack);
    }
  }

  Future<void> updateProduct(Product product, {XFile? image}) async {
    try {
      final updatedProduct = await _productService.updateProduct(
        product.id,
        product,
        image: await FileUtils.convertXFileToMultipart(image),
      );
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchProductsByCategory(
    int categoryId, {
    bool isRefresh = false,
  }) async {
    // --- GIAI ĐOẠN 1: THIẾT LẬP TRẠNG THÁI (SETUP) ---

    // TRƯỜNG HỢP 1: Reset / Đổi Category / Refresh
    if (isRefresh || categoryId != _currentCategoryId) {
      _currentPage = 0;
      _productViews = []; // Xóa list cũ ngay
      _currentCategoryId = categoryId;
      _hasMore = true; // QUAN TRỌNG: Phải reset cái này về true

      _isLoading = true; // Bật loading to
      _isMoreLoading = false; // Tắt loading nhỏ
      notifyListeners();
    }
    // TRƯỜNG HỢP 2: Load more (Kéo xuống đáy)
    else {
      // Chốt chặn (Guard Clause): Nếu đang load hoặc hết hàng thì nghỉ
      if (_isMoreLoading || !hasMore) {
        return;
      }

      _isLoading = false; // Đảm bảo loading to đang tắt
      _isMoreLoading = true; // Bật loading nhỏ
      notifyListeners();
    }

    // --- GIAI ĐOẠN 2: GỌI API (CHUNG CHO CẢ 2 TRƯỜNG HỢP) ---
    try {
      var res = await _productService.getProductsByCategory(
        categoryId,
        _currentPage,
        _pageSize,
      );

      // Xử lý dữ liệu trả về
      if (res.content.isNotEmpty) {
        // Logic nối list:
        // Vì ở TRƯỜNG HỢP 1 ta đã gán _productViews = [] rồi,
        // nên dùng addAll ở đây là an toàn cho cả 2 trường hợp.
        _productViews.addAll(res.content);

        _currentPage++; // Tăng page
        _totalPages = res.totalPages;

        // Cập nhật hasMore
        if (res.content.length < _pageSize) {
          _hasMore = false;
        }
      } else {
        // Nếu content rỗng -> hết dữ liệu
        _hasMore = false;
      }
    } catch (e) {
      print("Lỗi load product: $e");
    } finally {
      // --- GIAI ĐOẠN 3: DỌN DẸP ---
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  void loadMoreByCategory(int selectedCategoryId) {
    fetchProductsByCategory(selectedCategoryId, isRefresh: false);
  }

  void prepareForCategory(int categoryId) {
    _currentCategoryId = categoryId;
    _products = [];
    _productViews = [];
    _currentPage = 0;
    _hasMore = true;
    _isLoading = true; // bật loading lớn
    _isMoreLoading = false; // tắt loading nhỏ
    notifyListeners();
  }
}
