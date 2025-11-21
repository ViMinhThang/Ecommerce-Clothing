import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/screens/admin/products/edit/edit_product_screen.dart';
import 'package:frontend_client_mobile/widgets/admin/product_search_bar.dart';
import 'package:frontend_client_mobile/widgets/admin/product_list_view.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../widgets/shared/stats_card.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<ProductProvider>(context, listen: false).loadMore();
    }
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
          ).fetchProducts(refresh: true),
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
              // Stats Dashboard
              _buildStatsSection(provider),
              const SizedBox(height: 16),
              ProductSearchBar(
                onChanged: (value) => provider.searchProducts(value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchProducts(refresh: true),
                  child: ProductListView(
                    scrollController: _scrollController,
                    products: provider.products,
                    isLoading: provider.isLoading,
                    isMoreLoading: provider.isMoreLoading,
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(ProductProvider provider) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(
            width: 140,
            child: StatsCard(
              label: 'Products',
              value: '${provider.products.length}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: StatsCard(
              label: 'Categories',
              value: '8',
              icon: Icons.category_outlined,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: StatsCard(
              label: 'Total Variants',
              value: '45',
              icon: Icons.palette_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
