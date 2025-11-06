import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/screens/admin/categories/categories_function.dart';
import '../../../layouts/admin_layout.dart';
import 'edit_category_screen.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    categories = [
      {
        'id': 1,
        'name': 'Thời trang nam',
        'description': 'Các sản phẩm quần áo, phụ kiện dành cho nam giới',
        'status': 'active',
      },
      {
        'id': 2,
        'name': 'Thời trang nữ',
        'description': 'Các sản phẩm cho nữ giới',
        'status': 'inactive',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Category Management',
      selectedIndex: 4,
      actions: [
        IconButton(
          onPressed: () => setState(_loadMockData),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddCategory,
        backgroundColor: Colors.black,
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
        hintText: 'Search Category...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      onChanged: (query) {
        setState(() {
          // nếu sau này có API thì sẽ lọc tại đây
        });
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final c = categories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              c['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              c['description'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit Category',
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCategoryScreen(category: c),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        final index = categories.indexWhere(
                          (item) => item['id'] == updated['id'],
                        );
                        if (index != -1) categories[index] = updated;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Category',
                  onPressed: () => _onDeleteCategory(c),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddCategory() async {
    final newCategory = await addCategory(context, const EditCategoryScreen());
    if (newCategory != null) {
      setState(() => categories.add(newCategory));
    }
  }

  Future<void> _onDeleteCategory(Map<String, dynamic> category) async {
    final deleted = await deleteCategory(context, categories, category);
    if (deleted) setState(() {});
  }
}
