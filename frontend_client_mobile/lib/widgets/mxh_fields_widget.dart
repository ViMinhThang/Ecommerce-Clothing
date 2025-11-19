import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icondata;
  final String text;
  final Color textColor;
  final Color color;
  final VoidCallback? onTap;

  const SocialWidget({
    super.key,
    required this.icondata,
    required this.text,
    required this.textColor,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color,
          border: Border.all(color: textColor, width: 2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: icondata == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (icondata != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(icondata, color: textColor),
                ),
                SizedBox(width: 70),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
