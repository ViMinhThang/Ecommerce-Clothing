import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/screens/admin/categories/manage_categories_screen.dart';
import 'package:frontend_client_mobile/screens/admin/dashboard/dashboard_screen.dart';
import 'package:frontend_client_mobile/screens/admin/orders/manage_orders_screen.dart';
import 'package:frontend_client_mobile/screens/admin/products/manage_products_screen.dart';
import 'package:frontend_client_mobile/screens/admin/users/manage_users_screen.dart';

import 'package:frontend_client_mobile/screens/admin/sizes/manage_sizes_screen.dart';
import 'package:frontend_client_mobile/screens/admin/colors/manage_colors_screen.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => SizeProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/sizes': (context) => const ManageSizesScreen(),
        '/colors': (context) => const ManageColorsScreen(),
      },
    );
  }
}
