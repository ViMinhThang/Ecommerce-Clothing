import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/screens/profile/orders_screen.dart';
import 'package:frontend_client_mobile/screens/review/reviews_screen.dart';
import 'package:frontend_client_mobile/services/auth_service.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TokenStorage _tokenStorage = TokenStorage();
  String _username = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final roles = await _tokenStorage.readRoles();
    setState(() {
      _username = roles.contains('ROLE_ADMIN') ? 'Admin User' : 'User';
    });
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    await AuthService().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'My Account',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            _buildSectionTitle('Activity'),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildActivityChip(Icons.person_outline, 'Details', () {}),
                const SizedBox(width: 12),
                _buildActivityChip(Icons.shopping_bag_outlined, 'Orders', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  );
                }),
                const SizedBox(width: 12),
                _buildActivityChip(Icons.star_border, 'Reviews', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewsScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('Community'),
            const SizedBox(height: 20),
            _buildMenuItem(Icons.supervisor_account_outlined, 'Community influencer program'),
            const SizedBox(height: 36),
            _buildSectionTitle('Support'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildSupportItem(Icons.help_outline, 'FAQ')),
                Expanded(child: _buildSupportItem(Icons.chat_bubble_outline, 'Chat with us')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSupportItem(Icons.verified_user_outlined, 'Privacy policy')),
                Expanded(child: _buildSupportItem(Icons.info_outline, 'About us')),
              ],
            ),
            const SizedBox(height: 16),
            _buildMenuItem(Icons.lock_outline, 'Intellectual property'),
            const SizedBox(height: 36),
            _buildSectionTitle('Settings'),
            const SizedBox(height: 20),
            _buildMenuItem(Icons.language, 'Location & Language'),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade500,
                  side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildActivityChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
