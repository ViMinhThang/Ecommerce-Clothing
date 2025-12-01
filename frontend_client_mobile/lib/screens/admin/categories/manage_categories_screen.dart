import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_category_screen.dart';
import '../../../utils/image_helper.dart';

class ManageCategoriesScreen extends BaseManageScreen<model.Category> {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends BaseManageScreenState<model.Category, ManageCategoriesScreen> {
  CategoryProvider get _categoryProvider =>
      Provider.of<CategoryProvider>(context, listen: false);

  @override
  String getScreenTitle() => 'Category Management';

  @override
  int getSelectedIndex() => 4;

  @override
  String getEntityName() => 'category';

  @override
  IconData getEmptyStateIcon() => Icons.category_outlined;

  @override
  String getSearchHint() => 'Search Category...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _categoryProvider.fetchCategories();
    });
  }

  @override
  void refreshData() {
    _categoryProvider.fetchCategories();
  }

  @override
  void onSearchChanged(String query) {
    _categoryProvider.searchCategories(query);
  }

  @override
  List<model.Category> getItems() {
    return context.watch<CategoryProvider>().categories;
  }

  @override
  bool isLoading() {
    return context.watch<CategoryProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditCategoryScreen()),
    );
  }

  @override
  Future<void> navigateToEdit(model.Category item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCategoryScreen(entity: item)),
    );
  }

  @override
  Future<void> handleDelete(model.Category item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete category "${item.name}"?',
    );

    if (confirmed && mounted) {
      await _categoryProvider.removeCategory(item.id as int);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted "${item.name}"')));
      }
    }
  }

  Widget _buildLeadingWidget(model.Category item) {
    final imageUrl = ImageHelper.getFullImageUrl(item.imageUrl);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
      ),
      child: ClipRRect(
        borderRadius: AppTheme.borderRadiusSM,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, color: AppTheme.lightGray),
              )
            : Icon(Icons.image_not_supported, color: AppTheme.lightGray),
      ),
    );
  }

  String _getItemTitle(model.Category item) => item.name;

  Widget? _buildSubtitle(model.Category item) {
    return Text(
      item.description,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTheme.bodySmall,
    );
  }

  @override
  Widget buildList() {
    final items = getItems();
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AdminListItem(
          leading: _buildLeadingWidget(item),
          title: _getItemTitle(item),
          subtitle: _buildSubtitle(item),
          onEdit: () => navigateToEdit(item),
          onDelete: () => handleDelete(item),
          editTooltip: 'Edit Category',
          deleteTooltip: 'Delete Category',
        );
      },
    );
  }
}
