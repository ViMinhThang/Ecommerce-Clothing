import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final int selectedIndex;

  const AdminDrawer({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 28, backgroundColor: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Admin Panel',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          _drawerItem(
            context,
            Icons.dashboard,
            'Dashboard',
            '/dashboard',
            0,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.inventory,
            'Products',
            '/products',
            1,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.shopping_bag,
            'Orders',
            '/orders',
            2,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.people,
            'Users',
            '/users',
            3,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.people,
            'Categories',
            '/categories',
            4,
            selectedIndex,
          ),
          _drawerItem( // New item for Sizes
            context,
            Icons.straighten, // Using straighten icon for sizes
            'Sizes',
            '/sizes',
            5,
            selectedIndex,
          ),
          _drawerItem( // New item for Colors
            context,
            Icons.color_lens, // Using color_lens icon for colors
            'Colors',
            '/colors',
            6,
            selectedIndex,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.pop(context);
              // TODO: clear token và navigate login
            },
          ),
        ],
      ),
    );
  }

  static Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    int index,
    int selectedIndex,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index
            ? const Color.fromARGB(255, 0, 0, 0)
            : Colors.grey,
      ),
      title: Text(title),
      selected: selectedIndex == index,
      onTap: () {
        Navigator.pop(context);
        if (selectedIndex != index) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
