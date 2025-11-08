import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/services/color_service.dart';

class ColorProvider with ChangeNotifier {
  final ColorService _colorService = ColorService();
  List<Color> _colors = [];
  bool _isLoading = false;

  List<Color> get colors => _colors;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchColors();
    _isLoading = true;
  }

  Future<void> fetchColors() async {
    try {
      _colors = await _colorService.getColors();
    } catch (e) {
      // Handle error
    }
    notifyListeners();
  }
}
