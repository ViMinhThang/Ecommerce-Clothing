import 'package:flutter/material.dart';

class SocialRoundedWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final IconData? icondata;

  const SocialRoundedWidget({super.key, required this.icondata});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25), //hình tròn = width / 2
        border: Border.all(color: Colors.black),
      ),
      child: Center(child: Icon(icondata)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
