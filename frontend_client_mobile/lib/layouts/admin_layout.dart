import 'package:flutter/material.dart';
import '../widgets/admin/admin_drawer.dart';
import '../config/theme_config.dart';

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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: actions,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.primaryBlack),
      ),
      drawer: AdminDrawer(selectedIndex: selectedIndex),
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
