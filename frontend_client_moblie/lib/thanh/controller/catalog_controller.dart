import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/thanh/service/catalog_service.dart';
import 'package:frotend_client_moblie/thanh/view_model/catalog_card_view_model.dart';

class CatalogController extends ChangeNotifier {
  final CatalogService _service = CatalogService();

  // ----- TRẠNG THÁI (STATE) -----
  List<CatalogItemViewModel> _catalog_cards = [];
  bool _isLoading = false;
  String? _error;

  // ----- GETTERS (để UI đọc) -----
  List<CatalogItemViewModel> get catalog_cards => _catalog_cards;
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
      _catalog_cards = await _service.fetchCatalogCards();
    });
  }
}
