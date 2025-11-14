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
      print('Error fetching colors: $e');
    }
    notifyListeners();
  }

  Future<void> addColor(Color color) async {
    try {
      final newColor = await _colorService.createColor(color);
      _colors.add(newColor);
      notifyListeners();
    } catch (e) {
      print('Error adding color: $e');
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
    }
  }

  Future<void> removeColor(int id) async {
    try {
      await _colorService.deleteColor(id);
      _colors.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting color: $e');
    }
  }
}
