import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_category_screen.dart';

class ManageCategoriesScreen extends BaseManageScreen<model.Category> {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends BaseManageScreenState<model.Category, ManageCategoriesScreen>
    with SingleTickerProviderStateMixin {
  CategoryProvider get _categoryProvider =>
      Provider.of<CategoryProvider>(context, listen: false);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      _categoryProvider.fetchCategories().then((_) {
        if (mounted) _animationController.forward(from: 0);
      });
    });
  }

  @override
  void onScrollToBottom() {
    _categoryProvider.fetchMoreCategories();
  }

  @override
  void refreshData() {
    _categoryProvider.fetchCategories().then((_) {
      if (mounted) _animationController.forward(from: 0);
    });
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
    final provider = context.watch<CategoryProvider>();
    return provider.isLoading || provider.isFetchingMore;
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
    final imageUrl = FileUtils.fixImgUrl(item.imageUrl);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusXS,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2), // Outer ring effect
      child: ClipRRect(
        borderRadius: AppTheme.borderRadiusXS,
        child: Container(
          color: AppTheme.offWhite,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 20,
                    color: AppTheme.lightGray,
                  ),
                )
              : Icon(Icons.category, size: 24, color: AppTheme.lightGray),
        ),
      ),
    );
  }

  String _getItemTitle(model.Category item) => item.name;

  Widget? _buildSubtitle(model.Category item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.bodySmall.copyWith(
            height: 1.2,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildList() {
    final items = getItems();
    final provider = context.watch<CategoryProvider>();

    return SliverList.builder(
      itemCount: items.length + (provider.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];

          final animation = CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index * 0.1).clamp(0, 1.0),
              ((index * 0.1) + 0.5).clamp(0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: AdminListItem(
                leading: _buildLeadingWidget(item),
                title: _getItemTitle(item),
                subtitle: _buildSubtitle(item),
                onEdit: () => navigateToEdit(item),
                onDelete: () => handleDelete(item),
                editTooltip: 'Edit Category',
                deleteTooltip: 'Delete Category',
              ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
      },
    );
  }
}
