import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addProduct(
  BuildContext context,
  Widget editScreen,
) async {
  final newProduct = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newProduct;
}

Future<Map<String, dynamic>?> editProduct(
  BuildContext context,
  Map<String, dynamic> product,
  Widget editScreen,
) async {
  final updatedProduct = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return updatedProduct;
}

Future<bool> deleteProduct(
  BuildContext context,
  List<Map<String, dynamic>> products,
  Map<String, dynamic> product,
) async {
  final confirm = await showConfirmDialog(
    context,
    'Delete Confirm',
    'Are you sure you want to delete "${product['name']}"?',
  );

  if (confirm) {
    products.removeWhere((p) => p['id'] == product['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "${product['name']}"')));
    return true;
  }
  return false;
}
