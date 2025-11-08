import 'package:flutter/material.dart';
import '../widgets/admin/admin_drawer.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  const AdminLayout({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true, actions: actions),
      drawer: AdminDrawer(selectedIndex: selectedIndex),
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
