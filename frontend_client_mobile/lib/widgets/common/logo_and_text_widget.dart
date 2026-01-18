import 'package:flutter/material.dart';

class LogoTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final String? imageUrl;
  final double imgHeight;
  final double imgWidth;

  const LogoTextWidget({
    super.key,
    this.text = 'Welcome Back',
    this.textSize = 24,
    this.imageUrl,
    this.imgHeight = 80,
    this.imgWidth = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo or icon
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Image.asset(
            imageUrl!,
            height: imgHeight,
            width: imgWidth,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.shopping_bag,
                size: imgHeight,
                color: Theme.of(context).primaryColor,
              );
            },
          )
        else
          Icon(
            Icons.shopping_bag,
            size: imgHeight,
            color: Theme.of(context).primaryColor,
          ),
        const SizedBox(height: 16),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
