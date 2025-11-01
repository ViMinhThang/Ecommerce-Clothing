import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addOrder(
  BuildContext context,
  Widget editScreen,
) async {
  final newOrder = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newOrder;
}

Future<bool> deleteOrder(
  BuildContext context,
  List<Map<String, dynamic>> orders,
  Map<String, dynamic> order,
) async {
  final confirm = await showConfirmDialog(
    context,
    title: 'Delete Confirm',
    message: 'Are you sure you want to delete order #${order['id']}?',
  );

  if (confirm) {
    orders.removeWhere((o) => o['id'] == order['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa đơn hàng #${order['id']}')));
    return true;
  }

  return false;
}
