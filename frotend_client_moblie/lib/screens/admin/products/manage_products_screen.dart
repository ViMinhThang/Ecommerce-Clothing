import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/screens/admin/products/edit_product_screen.dart';
import 'package:frotend_client_moblie/screens/admin/products/products_function.dart';
import '../../../layouts/admin_layout.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    products = [
      {
        'id': 1,
        'name': 'Áo thun nam basic',
        'price': 199000,
        'stock': 24,
        'status': 'active',
        'image': 'https://via.placeholder.com/100x100.png?text=Product+1',
      },
      {
        'id': 2,
        'name': 'Quần jeans nữ xanh',
        'price': 399000,
        'stock': 12,
        'status': 'inactive',
        'image': 'https://via.placeholder.com/100x100.png?text=Product+2',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Product Management',
      selectedIndex: 1,
      actions: [
        IconButton(
          onPressed: () => setState(_loadMockData),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final newProduct = await addProduct(
            context,
            const EditProductScreen(),
          );
          if (newProduct != null) setState(() => products.add(newProduct));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search Product...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  Widget _buildListView() {
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
            leading: Image.network(
              p['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(p['name']),
            subtitle: Text('₫${p['price']} - Kho: ${p['stock']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit',
                  onPressed: () async {
                    final updated = await editProduct(
                      context,
                      p,
                      EditProductScreen(product: p),
                    );
                    if (updated != null) {
                      setState(() {
                        final i = products.indexWhere(
                          (item) => item['id'] == updated['id'],
                        );
                        if (i != -1) products[i] = updated;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Product',
                  onPressed: () async {
                    final deleted = await deleteProduct(context, products, p);
                    if (deleted) setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
