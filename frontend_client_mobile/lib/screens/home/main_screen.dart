import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/screens/cart/cart_screen.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_navigator.dart';
import 'package:frontend_client_mobile/screens/home/home_screen.dart';
import 'package:frontend_client_mobile/screens/wishlist/wishlist_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

      bottomNavigationBar: Consumer2<WishlistProvider, CartProvider>(
        builder: (context, wishlistProvider, cartProvider, child) {
          final cartItemCount = cartProvider.cart?.items.length ?? 0;
          
          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: wishlistProvider.itemCount > 0,
                  label: Text(
                    wishlistProvider.itemCount.toString(),
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
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],

            currentIndex: _selectedIndex,
            onTap: _onItemTapped,

            // --- Styling to match e-commerce app common practices ---
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guest User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to access your profile',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
