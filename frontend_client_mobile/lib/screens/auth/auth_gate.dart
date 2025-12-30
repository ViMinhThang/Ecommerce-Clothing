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
    final token = await _storage.readAccessToken();
    if (token == null) {
      setState(() => _authorized = false);
      return;
    }

    if (!widget.requireAdmin) {
      setState(() => _authorized = true);
      return;
    }

    // Nếu yêu cầu admin, cố gắng decode payload
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
        setState(() => _authorized = isAdmin);
        return;
      }
    } catch (_) {}

    setState(() => _authorized = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_authorized == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_authorized == false) {
      // chuyển về màn hình login
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
