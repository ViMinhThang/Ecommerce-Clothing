import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';
import 'edit_category_screen.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch categories when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).fetchCategories(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<CategoryProvider>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Category Management',
      selectedIndex: 4,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<CategoryProvider>(
              context,
              listen: false,
            ).fetchCategories(refresh: true);
          },
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
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                if (categoryProvider.isLoading &&
                    categoryProvider.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryProvider.categories.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      categoryProvider.fetchCategories(refresh: true),
                  child: _buildListView(
                    categoryProvider.categories,
                    categoryProvider.isMoreLoading,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusSM,
        boxShadow: AppTheme.shadowSM,
      ),
      child: TextField(
        controller: _searchController,
        style: AppTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppTheme.mediumGray),
          hintText: 'Search Category...',
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.lightGray),
          border: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: AppTheme.borderThin.top, // Use the thin border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: AppTheme.borderThin.top,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: const BorderSide(
              color: AppTheme.mediumGray,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: AppTheme.primaryWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (query) {
          // Filter logic will go here when API is integrated
        },
      ),
    );
  }

  Widget _buildListView(List<model.Category> categories, bool isMoreLoading) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemCount: categories.length + (isMoreLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at bottom
        if (index == categories.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final c = categories[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: AppTheme.borderRadiusMD,
            border: AppTheme.borderThin,
            boxShadow: AppTheme.shadowSM,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.offWhite,
                borderRadius: AppTheme.borderRadiusSM,
                border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
              ),
              child: ClipRRect(
                borderRadius: AppTheme.borderRadiusSM,
                child: c.imageUrl.isNotEmpty
                    ? Image.network(
                        c.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: AppTheme.lightGray),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: AppTheme.lightGray,
                      ),
              ),
            ),
            title: Text(c.name, style: AppTheme.h4.copyWith(fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                c.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.bodySmall,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
                  tooltip: 'Edit Category',
                  splashRadius: 20,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCategoryScreen(category: c),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF5350),
                  ),
                  tooltip: 'Delete Category',
                  splashRadius: 20,
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditCategoryScreen()),
    );
  }

  Future<void> _onDeleteCategory(model.Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirm'),
        content: Text(
          'Are you sure you want to delete category "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).removeCategory(category.id as int);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa "${category.name}"')));
    }
  }
}
