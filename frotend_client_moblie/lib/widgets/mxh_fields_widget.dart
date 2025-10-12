import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icondata;
  final String text;
  final Color textColor;
  final Color color;

  const SocialWidget({
    super.key,
    required this.icondata,
    required this.text,
    required this.textColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.1,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color,
        border: Border.all(color: textColor, width: 2),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(icondata, color: textColor),
            ),
            SizedBox(width: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
