import 'package:flutter/material.dart';
import '../../../utils/dialogs.dart';

Future<Map<String, dynamic>?> addUser(
  BuildContext context,
  Widget editScreen,
) async {
  final newUser = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => editScreen),
  );
  return newUser;
}

Future<bool> deleteUser(
  BuildContext context,
  List<Map<String, dynamic>> users,
  Map<String, dynamic> user,
) async {
  final confirm = await showConfirmDialog(
    context,
    title: 'Delete Confirm',
    message: 'Are you sure you want to delete user "${user['name']}"?',
  );

  if (confirm) {
    users.removeWhere((u) => u['id'] == user['id']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa "${user['name']}"')));
    return true;
  }

  return false;
}
