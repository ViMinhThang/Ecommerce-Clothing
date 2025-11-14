import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addSize(
  BuildContext context,
  Widget editScreen,
) async {
  final newSize = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newSize;
}

Future<bool> deleteSize(
  BuildContext context,
  List<Map<String, dynamic>> sizes,
  Map<String, dynamic> size,
) async {
  final confirm = await showConfirmDialog(
    context,
    title: 'Delete Confirm',
    message: 'Are you sure you want to delete size "${size['name']}"?',
  );

  if (confirm) {
    sizes.removeWhere((s) => s['id'] == size['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "${size['name']}"')));
    return true;
  }

  return false;
}
