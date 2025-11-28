import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
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
import 'package:frontend_client_mobile/screens/auth/log_in.dart';
import 'package:frontend_client_mobile/screens/auth/onBoarding_screen.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => SizeProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        "/": (context) => const OnboardingScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const MainScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/products': (context) => const ManageProductsScreen(),
        '/categories': (context) => const ManageCategoriesScreen(),
        '/users': (context) => const ManageUsersScreen(),
        '/orders': (context) => const ManageOrdersScreen(),
        '/sizes': (context) => const ManageSizesScreen(),
        '/colors': (context) => const ManageColorsScreen(),
      },
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppTheme.background,
        primaryColor: AppTheme.primaryBlack,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppTheme.primaryBlack,
          onPrimary: AppTheme.primaryWhite,
          secondary: AppTheme.primaryBlack,
          onSecondary: AppTheme.primaryWhite,
          background: AppTheme.background,
          onBackground: AppTheme.primaryBlack,
          surface: AppTheme.primaryWhite,
          onSurface: AppTheme.primaryBlack,
          error: Colors.red,
          onError: AppTheme.primaryWhite,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.primaryBlack,
          foregroundColor: AppTheme.primaryWhite,
          elevation: 2,
          titleTextStyle: AppTheme.h2,
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlack,
            foregroundColor: AppTheme.primaryWhite,
            textStyle: AppTheme.button,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadiusSM,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryBlack,
            textStyle: AppTheme.button,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppTheme.primaryBlack,
          foregroundColor: AppTheme.primaryWhite,
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.primaryWhite,
          border: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: BorderSide(color: AppTheme.mediumGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: BorderSide(color: AppTheme.primaryBlack),
          ),
        ),
      ),
    );
  }
}
