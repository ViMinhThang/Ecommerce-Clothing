import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product.dart'; // Adjust import

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final Function(Product) onEdit;
  final Function(Product) onDelete;

  const ProductListView({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: (p.imageUrl != null && p.imageUrl!.isNotEmpty)
                ? Image.network(
                    p.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
            title: Text(p.name),
            subtitle: Text(p.priceDisplayText), // Use new getter
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit',
                  onPressed: () => onEdit(p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Product',
                  onPressed: () => onDelete(p),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
