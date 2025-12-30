import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:provider/provider.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);

    return Row(
      children: [
        // Quantity Selector
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove, size: 20, color: Colors.grey),
                onPressed: provider.decrementQuantity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${provider.quantity}',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add, size: 20, color: Colors.black),
                onPressed: provider.incrementQuantity,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Add to Cart Button
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed:
                  provider.isLoadingVariants ||
                      provider.selectedVariantId == null
                  ? null
                  : () async {
                      final cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      final success = await cartProvider.addToCart(
                        userId: 1,
                        variantId: provider.selectedVariantId!,
                        quantity: provider.quantity,
                      );

                      if (!context.mounted) return;
                      final messenger = ScaffoldMessenger.of(context);
                      if (success) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              cartProvider.error ?? 'Failed to add to cart',
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add to cart',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
