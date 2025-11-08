import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/services/size_service.dart';

class SizeProvider with ChangeNotifier {
  final SizeService _sizeService = SizeService();
  List<Size> _sizes = [];
  bool _isLoading = false;

  List<Size> get sizes => _sizes;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchSizes();
    _isLoading = true;
  }

  Future<void> fetchSizes() async {
    try {
      _sizes = await _sizeService.getSizes();
    } catch (e) {
      // Handle error
    }
    notifyListeners();
  }
}
