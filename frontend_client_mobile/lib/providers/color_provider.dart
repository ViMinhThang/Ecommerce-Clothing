import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/services/color_service.dart';

class ColorProvider with ChangeNotifier {
  final ColorService _colorService = ColorService();
  List<Color> _colors = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Color> get colors => _colors;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchColors();
    _isLoading = true;
  }

  Future<void> fetchColors() async {
    try {
      _colors = await _colorService.getColors(
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );
    } catch (e) {
      debugPrint('Error fetching colors: $e');
    }
    notifyListeners();
  }

  Future<void> searchColors(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchColors();
  }

  Future<void> addColor(Color color) async {
    try {
      final newColor = await _colorService.createColor(color);
      _colors.add(newColor);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding color: $e');
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
      debugPrint('Error updating color: $e');
    }
  }

  Future<void> removeColor(int id) async {
    try {
      await _colorService.deleteColor(id);
      _colors.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting color: $e');
    }
  }
}
