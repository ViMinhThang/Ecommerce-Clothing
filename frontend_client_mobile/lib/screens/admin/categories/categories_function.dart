import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addCategory(
  BuildContext context,
  Widget editScreen,
) async {
  final newCategory = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newCategory;
}

Future<bool> deleteCategory(
  BuildContext context,
  List<Map<String, dynamic>> categories,
  Map<String, dynamic> category,
) async {
  final confirm = await showConfirmDialog(
    context,
    title: 'Delete Confirm',
    message: 'Are you sure you want to delete category "${category['name']}"?',
  );

  if (confirm) {
    categories.removeWhere((c) => c['id'] == category['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "${category['name']}"')));
    return true;
  }

  return false;
}
