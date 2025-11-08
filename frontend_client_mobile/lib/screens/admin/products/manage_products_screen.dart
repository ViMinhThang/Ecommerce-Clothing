import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/screens/admin/products/edit/edit_product_screen.dart';
import 'package:frontend_client_mobile/widgets/admin/product_search_bar.dart';
import 'package:frontend_client_mobile/widgets/admin/product_list_view.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Product Management',
      selectedIndex: 1,
      actions: [
        IconButton(
          onPressed: () => Provider.of<ProductProvider>(
            context,
            listen: false,
          ).fetchProducts(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProductScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              ProductSearchBar(
                onChanged: (value) => provider.searchProducts(value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ProductListView(
                  products: provider.products,
                  isLoading: provider.isLoading,
                  onEdit: (product) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProductScreen(product: product),
                      ),
                    );
                  },
                  onDelete: (product) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: const Text(
                          'Are you sure you want to delete this product?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      provider.deleteProduct(product.id);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
