import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/screens/admin/categories/manage_categories_screen.dart';
import 'package:frontend_client_mobile/screens/admin/dashboard/dashboard_screen.dart';
import 'package:frontend_client_mobile/screens/auth/auth_gate.dart';
import 'package:frontend_client_mobile/screens/admin/orders/manage_orders_screen.dart';
import 'package:frontend_client_mobile/screens/admin/products/manage_products_screen.dart';
import 'package:frontend_client_mobile/screens/admin/users/manage_users_screen.dart';
import 'package:frontend_client_mobile/screens/admin/sizes/manage_sizes_screen.dart';
import 'package:frontend_client_mobile/screens/admin/colors/manage_colors_screen.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:frontend_client_mobile/providers/dashboard_provider.dart';
import 'package:frontend_client_mobile/providers/user_provider.dart';
import 'package:frontend_client_mobile/providers/order_provider.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:frontend_client_mobile/screens/product/product.dart';
import 'package:frontend_client_mobile/screens/cart/my_cart.dart';
import 'package:frontend_client_mobile/screens/checkout/payment_method.dart';
import 'package:frontend_client_mobile/screens/checkout/status_checkout.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/screens/cart/cart_screen.dart';
import 'package:frontend_client_mobile/screens/checkout/checkout_screen.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/screens/wishlist/wishlist_screen.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/screens/auth/log_in.dart';
import 'package:frontend_client_mobile/screens/auth/onBoarding_screen.dart';
import 'package:frontend_client_mobile/providers/search_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => SizeProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(
          create: (context) => CartProvider(ApiClient.dio),
        ),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Admin',
      initialRoute: '/',
      routes: {
        "/": (context) => const OnboardingScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const MainScreen(),
        '/main': (context) => const MainScreen(),
        '/product': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final productId = args?['productId'] as int? ?? 1;
          return ProductDetailScreen(productId: productId);
        },
        '/cart': (context) => const MyCart(),
        '/payment': (context) => const PaymentMethodScreen(),
        '/checkout-status': (context) => const StatusCheckoutScreen(),
        '/dashboard': (context) =>
            const AuthGate(child: DashboardScreen(), requireAdmin: true),
        '/products': (context) => const ManageProductsScreen(),
        '/categories': (context) => const ManageCategoriesScreen(),
        '/users': (context) => const ManageUsersScreen(),
        '/orders': (context) => const ManageOrdersScreen(),
        '/sizes': (context) => const ManageSizesScreen(),
        '/colors': (context) => const ManageColorsScreen(),
        '/cart-legacy': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/wishlist': (context) => const WishListScreen(),
      },
    );
  }
}
