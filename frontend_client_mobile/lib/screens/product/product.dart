import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:provider/provider.dart';

import 'components/product_images.dart';
import 'components/product_header.dart';
import 'components/product_selection.dart';
import 'components/product_actions.dart';
import 'components/product_info_tabs.dart';
import 'components/related_products.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProductDetailProvider(productId: productId)
            ..fetchProductAndVariants(),
      child: const _ProductDetailContent(),
    );
  }
}

class _ProductDetailContent extends StatefulWidget {
  const _ProductDetailContent();

  @override
  State<_ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<_ProductDetailContent> {
  int _selectedNavIndex = 1; // Catalog selected by default

  void _onNavItemTapped(int index) {
    if (index == _selectedNavIndex) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(initialTab: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImages(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductHeader(),
                    SizedBox(height: 24),
                    ProductSelection(),
                    SizedBox(height: 24),
                    ProductActions(),
                    SizedBox(height: 24),
                    ProductInfoTabs(),
                    SizedBox(height: 24),
                    RelatedProducts(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer2<CartProvider, WishlistProvider>(
        builder: (context, cartProvider, wishlistProvider, child) {
          final cartItemCount = cartProvider.cart?.items.length ?? 0;
          final wishlistItemCount = wishlistProvider.itemCount;

          return BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Catalog',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: wishlistItemCount > 0,
                  label: Text(
                    wishlistItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.favorite_border),
                ),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: cartItemCount > 0,
                  label: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedNavIndex,
            onTap: _onNavItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
