import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final int selectedIndex;

  const AdminDrawer({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
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
            'Sản phẩm',
            '/products',
            1,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.shopping_bag,
            'Đơn hàng',
            '/orders',
            2,
            selectedIndex,
          ),
          _drawerItem(
            context,
            Icons.people,
            'Người dùng',
            '/users',
            3,
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
        color: selectedIndex == index ? Colors.blue : Colors.grey,
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
