// file: product_controller.dart
import 'package:flutter/material.dart';

import 'package:frotend_client_moblie/thanh/service/product_service.dart';
import 'package:frotend_client_moblie/thanh/view_model/product_view_model.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service = ProductService();

  // ----- TRẠNG THÁI (STATE) -----
  List<ProductViewModel> _products = [];
  bool _isLoading = false;
  String? _error;

  // ----- GETTERS (để UI đọc) -----
  List<ProductViewModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ----- HÀM HELPER (Mẹo để code gọn) -----
  // Hàm này xử lý loading/error/notify cho tất cả các hành động
  Future<void> _runAction(Future<void> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Báo UI: Bắt đầu loading

    try {
      await action(); // Thực hiện hành động (ví dụ: gọi service)
    } catch (e) {
      _error = e.toString(); // Ghi lại lỗi
    } finally {
      _isLoading = false;
      notifyListeners(); // Báo UI: Xong rồi (dù thành công hay lỗi)
    }
  }

  // ----- CÁC HÀM LOGIC (CRUD) -----

  // READ
  Future<void> fetchProducts() async {
    await _runAction(() async {
      _products = await _service.fetchProducts();
    });
  }
}
