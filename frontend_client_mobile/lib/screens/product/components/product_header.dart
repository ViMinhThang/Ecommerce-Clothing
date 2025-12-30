import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);
    final product = provider.product;
    final isLoading = provider.isLoadingProduct;
    final isLoadingVariants = provider.isLoadingVariants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: isLoading
                  ? const Text('Loading...', style: TextStyle(fontSize: 18))
                  : Text(
                      product?.name ?? 'Product Name',
                      style: GoogleFonts.lora(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
            ),
            Consumer<WishlistProvider>(
              builder: (context, wishlistProvider, child) {
                final isFav = product != null && 
                    wishlistProvider.isProductInWishlistLocal(product.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.black,
                  ),
                  onPressed: () async {
                    if (product != null) {
                      final success = await wishlistProvider.toggleWishlist(
                        productId: product.id,
                      );
                      if (!context.mounted) return;
                      if (success) {
                        final isNowFavorite = wishlistProvider.isProductInWishlistLocal(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isNowFavorite 
                                  ? 'Added to wishlist!' 
                                  : 'Removed from wishlist',
                            ),
                            backgroundColor: isNowFavorite ? Colors.green : Colors.grey,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...List.generate(
              5,
              (_) => const Icon(Icons.star, color: Colors.black, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              '5.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (provider.hasDiscount && !isLoadingVariants) ...[
              Text(
                provider.basePriceDisplay,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
            ],
            isLoadingVariants
                ? const Text('...')
                : Text(
                    provider.salePriceDisplay,
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
