import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_navigator.dart';
import 'package:frontend_client_mobile/screens/home/home_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/catalog/catalog_navigator.dart';
import 'package:frontend_client_mobile/thanh/screens/home_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/profile_screen.dart';
import 'package:frontend_client_mobile/screens/favorite/favorite_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CatalogNavigator(),
    Placeholder(), // Favorite screen (to be implemented)
    Placeholder(), // Shopping bag screen (to be implemented)
    ProfileScreen(),
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CatalogNavigator(),
    const FavoriteScreen(),
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
      // IndexedStack maintains the state of all screens (no rebuild on switch)
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
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

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
