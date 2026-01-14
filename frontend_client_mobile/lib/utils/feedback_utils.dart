import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackUtils {
  static void showWishlistToast(
    BuildContext context, {
    required bool isAdded,
    String? productName,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isAdded
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAdded
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isAdded ? Colors.pinkAccent : Colors.white70,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAdded ? 'Saved to Wishlist' : 'Removed from Wishlist',
                      style: GoogleFonts.lora(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (productName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        productName,
                        style: GoogleFonts.lora(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (isAdded)
                TextButton(
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    Navigator.pushNamed(
                      context,
                      '/home',
                      arguments: 2,
                    ); // Wishlist tab is 2
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    'VIEW',
                    style: GoogleFonts.lora(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
