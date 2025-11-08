import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isVisible;

  const LoadingOverlay({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    return Container(
      color: Colors.black26,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
