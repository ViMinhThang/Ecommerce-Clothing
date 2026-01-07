import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/voucher_api_service.dart';

class VoucherProvider extends ChangeNotifier {
  List<Voucher> _vouchers = [];
  bool _isLoading = false;
  String? _error;

  List<Voucher> get vouchers => _vouchers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  VoucherApiService get _apiService => ApiClient.getVoucherApiService();

  Future<void> loadVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vouchers = await _apiService.getAllVouchers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVoucher(Map<String, dynamic> data) async {
    try {
      final voucher = await _apiService.createVoucher(data);
      _vouchers.insert(0, voucher);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateVoucher(int id, Map<String, dynamic> data) async {
    try {
      final voucher = await _apiService.updateVoucher(id, data);
      final index = _vouchers.indexWhere((v) => v.id == id);
      if (index >= 0) {
        _vouchers[index] = voucher;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVoucher(int id) async {
    try {
      await _apiService.deleteVoucher(id);
      _vouchers.removeWhere((v) => v.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<ValidateVoucherResponse?> validateVoucher(String code, double orderAmount) async {
    try {
      return await _apiService.validateVoucher({
        'code': code,
        'orderAmount': orderAmount,
      });
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }
}
