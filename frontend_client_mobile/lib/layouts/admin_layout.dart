import 'package:flutter/material.dart';
import '../widgets/admin/admin_drawer.dart';
import '../config/theme_config.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final String? currentPage;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  const AdminLayout({
    super.key,
    this.title = '',
    this.selectedIndex = 0,
    this.currentPage,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate selectedIndex based on currentPage
    int calculatedIndex = selectedIndex;
    if (currentPage != null) {
      switch (currentPage) {
        case 'dashboard': calculatedIndex = 0; break;
        case 'products': calculatedIndex = 1; break;
        case 'categories': calculatedIndex = 2; break;
        case 'orders': calculatedIndex = 3; break;
        case 'users': calculatedIndex = 4; break;
        case 'sizes': calculatedIndex = 5; break;
        case 'colors': calculatedIndex = 6; break;
        case 'vouchers': calculatedIndex = 7; break;
        case 'inventory': calculatedIndex = 8; break;
      }
    }
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(title.isEmpty ? (currentPage ?? '').toUpperCase() : title),
        centerTitle: true,
        actions: actions,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.primaryBlack),
      ),
      drawer: AdminDrawer(selectedIndex: calculatedIndex),
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
