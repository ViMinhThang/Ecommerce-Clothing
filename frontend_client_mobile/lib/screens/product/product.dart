import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
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

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent();

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
      bottomNavigationBar: const _ProductDetailBottomNav(),
    );
  }
}

class _ProductDetailBottomNav extends StatelessWidget {
  const _ProductDetailBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      currentIndex: 1,
      onTap: (index) {
        if (index == 1) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(initialTab: 1),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(initialTab: index),
            ),
          );
        }
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );
  }
}
