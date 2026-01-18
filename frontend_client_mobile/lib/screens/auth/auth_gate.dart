import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

class AuthGate extends StatefulWidget {
  final Widget child;
  final bool requireAdmin;
  const AuthGate({super.key, required this.child, this.requireAdmin = false});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final TokenStorage _storage = TokenStorage();
  bool? _authorized;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    // Add a small delay to ensure the token has been saved after login
    await Future.delayed(const Duration(milliseconds: 100));
    
    final token = await _storage.readAccessToken();
    debugPrint('AuthGate: Token check - ${token != null ? "Found" : "Not found"}');
    
    if (token == null || token.isEmpty) {
      debugPrint('AuthGate: No token, unauthorized');
      if (mounted) setState(() => _authorized = false);
      return;
    }

    if (!widget.requireAdmin) {
      debugPrint('AuthGate: Token found, no admin required, authorized');
      if (mounted) setState(() => _authorized = true);
      return;
    }

    // If admin is required, decode token to check roles
    try {
      final parts = token.split('.');
      if (parts.length >= 2) {
        final payload = base64.normalize(parts[1]);
        final decoded = utf8.decode(base64.decode(payload));
        final Map<String, dynamic> obj = jsonDecode(decoded);
        final roles = obj['roles'] ?? obj['role'] ?? obj['authorities'];
        // đơn giản kiểm tra chuỗi 'ADMIN' hoặc 'ROLE_ADMIN'
        final isAdmin =
            roles != null && roles.toString().toUpperCase().contains('ADMIN');
        debugPrint('AuthGate: Admin check - $isAdmin (roles: $roles)');
        if (mounted) setState(() => _authorized = isAdmin);
        return;
      }
    } catch (e) {
      debugPrint('AuthGate: Error decoding token - $e');
    }

    if (mounted) setState(() => _authorized = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_authorized == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_authorized == false) {
      // Navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          debugPrint('AuthGate: Redirecting to login - unauthorized');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false, // Xóa toàn bộ navigation stack
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
