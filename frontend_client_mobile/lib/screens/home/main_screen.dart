import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/screens/cart/cart_screen.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_navigator.dart';
import 'package:frontend_client_mobile/screens/home/home_screen.dart';
import 'package:frontend_client_mobile/screens/wishlist/wishlist_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialTab;

  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      setState(() {
        _selectedIndex = widget.initialTab;
      });
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CatalogNavigator(),
    const WishListScreen(),
    const CartScreen(),
    const _ProfilePlaceholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: Consumer2<CartProvider, WishlistProvider>(
        builder: (context, cartProvider, wishlistProvider, child) {
          final cartItemCount = cartProvider.cart?.items.length ?? 0;
          final wishlistItemCount = wishlistProvider.itemCount;

          return BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
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

            currentIndex: _selectedIndex,
            onTap: _onItemTapped,

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

// Placeholder for Profile screen
class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header
              Text(
                'My Profile',
                style: GoogleFonts.lora(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Fashion Icon Container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade100,
                      Colors.grey.shade200,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 32),
              // Welcome Text
              Text(
                'Welcome to Shop',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to track orders, save favorites,\nand get personalized recommendations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to login screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to register screen
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Account',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Continue as Guest
              TextButton(
                onPressed: () {
                  // Continue browsing
                },
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
