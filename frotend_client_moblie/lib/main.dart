import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/screens/admin/dashboard/dashboard_screen.dart';
import 'package:frotend_client_moblie/screens/admin/products/manage_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Admin',
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/products': (context) => const ManageProductsScreen(),
        // '/orders': (context) => const ManageOrdersScreen(),
        // '/users': (context) => const ManageUsersScreen(),
      },
    );
  }
}
