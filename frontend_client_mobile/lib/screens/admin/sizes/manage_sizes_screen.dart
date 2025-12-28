import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/status_badge.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_size_screen.dart';

class ManageSizesScreen extends BaseManageScreen<model.Size> {
  const ManageSizesScreen({super.key});

  @override
  State<ManageSizesScreen> createState() => _ManageSizesScreenState();
}

class _ManageSizesScreenState
    extends BaseManageScreenState<model.Size, ManageSizesScreen> {
  SizeProvider get _sizeProvider =>
      Provider.of<SizeProvider>(context, listen: false);

  @override
  String getScreenTitle() => 'Size Management';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'size';

  @override
  IconData getEmptyStateIcon() => Icons.straighten_outlined;

  @override
  String getSearchHint() => 'Search Size...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sizeProvider.fetchSizes();
    });
  }

  @override
  void refreshData() {
    _sizeProvider.fetchSizes();
  }

  @override
  void onSearchChanged(String query) {
    _sizeProvider.searchSizes(query);
  }

  @override
  List<model.Size> getItems() {
    return context.watch<SizeProvider>().sizes;
  }

  @override
  bool isLoading() {
    return context.watch<SizeProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditSizeScreen()),
    );
  }

  @override
  Future<void> navigateToEdit(model.Size item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditSizeScreen(entity: item)),
    );
  }

  @override
  Future<void> handleDelete(model.Size item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete size "${item.sizeName}"?',
    );

    if (confirmed && mounted) {
      await _sizeProvider.removeSize(item.id as int);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted "${item.sizeName}"')));
      }
    }
  }

  Widget _buildLeadingWidget(model.Size item) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
      ),
      child: Center(
        child: Text(
          item.sizeName.substring(0, 1).toUpperCase(),
          style: AppTheme.h4.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  String _getItemTitle(model.Size item) => item.sizeName;

  Widget? _buildSubtitle(model.Size item) {
    return StatusBadge(label: item.status);
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
          editTooltip: 'Edit Size',
          deleteTooltip: 'Delete Size',
        );
      },
    );
  }
}
