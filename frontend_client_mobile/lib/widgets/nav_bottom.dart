import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem("assets/images/nav_home.png", 0),
          _navItem("assets/images/nav_menu.png", 1),
          _cartItem(), // special (có badge)
          _navItem("assets/images/nav_heart.png", 3),
          _navItem("assets/images/nav_user.png", 4),
        ],
      ),
    );
  }

  Widget _navItem(String iconPath, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Image.asset(
        iconPath,
        height: 30,
        width: 30,
        color: currentIndex == index ? Colors.black : Colors.grey,
      ),
    );
  }

  /// CART ITEM + BADGE
  Widget _cartItem() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/images/nav_cart.png",
            height: 30,
            width: 30,
            color: currentIndex == 2 ? Colors.black : Colors.grey,
          ),

          // BADGE
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
