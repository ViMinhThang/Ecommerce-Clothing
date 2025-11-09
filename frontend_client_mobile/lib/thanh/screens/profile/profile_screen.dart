import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/models/user.dart';
import 'package:frontend_client_mobile/services/user_service.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/edit_profile_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/orders_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/favorites_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/settings_screen.dart';
import 'package:frontend_client_mobile/thanh/screens/profile/shipping_address_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      // TODO: Replace with actual user ID from authentication
      final user = await _userService.getUser(1);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      // If API fails, use mock data
      setState(() {
        _user = User(
          id: 1,
          username: 'user123',
          email: 'user@example.com',
          fullName: 'Nguyễn Văn A',
          phone: '0123456789',
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final screenTheme = base.copyWith(
      textTheme: GoogleFonts.loraTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.lora(
          textStyle: base.textTheme.titleLarge?.copyWith(
            color: base.colorScheme.onPrimary,
          ),
        ),
      ),
    );

    return Theme(
      data: screenTheme,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _user?.avatarUrl != null
                                ? NetworkImage(_user!.avatarUrl!)
                                : null,
                            child: _user?.avatarUrl == null
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      Text(
                        _user?.fullName ?? _user?.username ?? 'User',
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        _user?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Edit Profile Button
                      OutlinedButton(
                        onPressed: () async {
                          if (_user != null) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(user: _user!),
                              ),
                            );
                            if (result == true) {
                              _loadUser(); // Reload user data
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Menu Items Section
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      subtitle: 'View your order history',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Favorites',
                      subtitle: 'Your saved items',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Address',
                      subtitle: 'Manage your addresses',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShippingAddressScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      subtitle: 'Manage payment options',
                      onTap: () {
                        // Navigate to payment methods screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage notification settings',
                      onTap: () {
                        // Navigate to notifications screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'App settings and preferences',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact us',
                      onTap: () {
                        // Navigate to help screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement logout logic here
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginScreen()),
                // );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

