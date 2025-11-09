import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addColor(
  BuildContext context,
  Widget editScreen,
) async {
  final newColor = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newColor;
}

Future<bool> deleteColor(
  BuildContext context,
  List<Map<String, dynamic>> colors,
  Map<String, dynamic> color,
) async {
  final confirm = await showConfirmDialog(
    context,
    title: 'Delete Confirm',
    message: 'Are you sure you want to delete color "${color['name']}"?',
  );

  if (confirm) {
    colors.removeWhere((c) => c['id'] == color['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "${color['name']}"')));
    return true;
  }

  return false;
}
