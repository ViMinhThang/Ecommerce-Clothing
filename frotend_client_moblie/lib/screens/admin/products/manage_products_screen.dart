import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/utils/dialogs.dart';
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
      title: 'Quản lý sản phẩm',
      selectedIndex: 1,
      actions: [
        IconButton(
          onPressed: () => setState(_loadMockData),
          icon: const Icon(Icons.refresh),
        ),
      ],
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
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Tìm kiếm sản phẩm...',
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
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Chỉnh sửa',
                  onPressed: () => print(p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Xóa sản phẩm',
                  onPressed: () => _onDeleteProduct(p),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onDeleteProduct(Map<String, dynamic> product) async {
    final confirm = await showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa "${product['name']}" không?',
    );

    if (confirm) {
      setState(() {
        products.removeWhere((p) => p['id'] == product['id']);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa "${product['name']}"')));
    }
  }
}
