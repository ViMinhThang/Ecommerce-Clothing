import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/screens/admin/categories/manage_categories_screen.dart';
import 'package:frotend_client_moblie/screens/admin/dashboard/dashboard_screen.dart';
import 'package:frotend_client_moblie/screens/admin/orders/manage_orders_screen.dart';
import 'package:frotend_client_moblie/screens/admin/products/manage_products_screen.dart';
import 'package:frotend_client_moblie/screens/admin/users/manage_users_screen.dart';

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
        '/categories': (context) => const ManageCategoriesScreen(),
        '/users': (context) => const ManageUsersScreen(),
        '/orders': (context) => const ManageOrdersScreen(),
      },
    );
  }
}
