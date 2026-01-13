import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/providers/favorite_provider.dart';
import 'package:frontend_client_mobile/models/favorite_item.dart';
import 'package:frontend_client_mobile/screens/product/product.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorite = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (favorite.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Xóa tất cả?'),
                    content: const Text(
                      'Bạn có chắc chắn muốn xóa tất cả sản phẩm yêu thích?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Không'),
                      ),
                      TextButton(
                        onPressed: () {
                          favorite.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Xóa'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Xóa tất cả'),
            ),
        ],
      ),
      body: favorite.items.isEmpty
          ? const Center(child: Text('Chưa có sản phẩm yêu thích'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: favorite.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (ctx, i) {
                final FavoriteItem item = favorite.items[i];
                return ListTile(
                  leading: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.image_not_supported),
                          ),
                        )
                      : const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.shopping_bag),
                        ),
                  title: Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('₫${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => favorite.removeItem(item.productId),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(productId: item.productId),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
