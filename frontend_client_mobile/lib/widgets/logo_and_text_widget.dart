import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoTextWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final double textSize;
  final String imageUrl;
  final double imgWidth;
  final double imgHeight;

  const LogoTextWidget({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.textSize,
    required this.imgWidth,
    required this.imgHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Image.asset(
            imageUrl,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.playfairDisplay(
              color: Colors.black,
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(imgHeight + 10 + textSize + 20);
}
