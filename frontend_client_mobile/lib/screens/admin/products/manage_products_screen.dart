import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:frontend_client_mobile/screens/admin/products/edit/edit_product_screen.dart';
import 'package:frontend_client_mobile/widgets/admin/product_list_view.dart';
import 'package:provider/provider.dart';

import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import '../../../widgets/shared/stats_card.dart';

class ManageProductsScreen extends BaseManageScreen<Product> {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState
    extends BaseManageScreenState<Product, ManageProductsScreen> {
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  ProductProvider get _productProvider =>
      Provider.of<ProductProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productProvider.loadMore();
    }
  }

  @override
  String getScreenTitle() => 'Product Management';

  @override
  int getSelectedIndex() => 1;

  @override
  String getEntityName() => 'product';

  @override
  IconData getEmptyStateIcon() => Icons.inventory_2_outlined;

  @override
  String getSearchHint() => 'Search Product...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.fetchProducts(refresh: true);
    });
  }

  @override
  void refreshData() {
    _productProvider.fetchProducts(refresh: true);
  }

  @override
  List<Product> getItems() {
    return context.watch<ProductProvider>().products;
  }

  @override
  bool isLoading() {
    return context.watch<ProductProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProductScreen()),
    );
  }

  @override
  Future<void> navigateToEdit(Product item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProductScreen(product: item)),
    );
  }

  @override
  Future<void> handleDelete(Product item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete this product?',
    );

    if (confirmed && mounted) {
      _productProvider.deleteProduct(item.id);
    }
  }

  @override
  List<Widget> buildHeaderWidgets() {
    return [
      Consumer<ProductProvider>(
        builder: (context, provider, child) => _buildStatsSection(provider),
      ),
    ];
  }

  @override
  Widget buildList() {
    final provider = context.watch<ProductProvider>();
    return ProductListView(
      scrollController: _scrollController,
      products: provider.products,
      isLoading: provider.isLoading,
      isMoreLoading: provider.isMoreLoading,
      onEdit: navigateToEdit,
      onDelete: handleDelete,
    );
  }

  Widget _buildStatsSection(ProductProvider provider) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ), // Reduced padding as parent has padding
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

  @override
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _productProvider.searchProducts(query);
    });
  }
}
