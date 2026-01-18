import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget {
  final String type;
  final String text;

  const SocialWidget({
    super.key,
    required this.type,
    required this.text,
  });

  IconData _getIcon() {
    switch (type.toLowerCase()) {
      case 'google':
        return Icons.g_mobiledata;
      case 'facebook':
        return Icons.facebook;
      case 'apple':
        return Icons.apple;
      default:
        return Icons.login;
    }
  }

  Color _getColor() {
    switch (type.toLowerCase()) {
      case 'google':
        return Colors.red;
      case 'facebook':
        return Colors.blue;
      case 'apple':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // Handle social login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text - Coming soon')),
        );
      },
      icon: Icon(_getIcon(), color: _getColor()),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
