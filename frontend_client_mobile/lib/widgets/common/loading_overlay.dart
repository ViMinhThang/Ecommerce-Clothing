import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isVisible;
  final Widget? child;

  const LoadingOverlay({super.key, required this.isVisible, this.child});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child ?? const SizedBox.shrink();
    }

    return Stack(
      children: [
        if (child != null) child!,
        Container(
          color: Colors.black.withOpacity(0.3),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
