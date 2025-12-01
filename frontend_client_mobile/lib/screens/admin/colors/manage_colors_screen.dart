import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as model;
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/status_badge.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_color_screen.dart';

class ManageColorsScreen extends BaseManageScreen<model.Color> {
  const ManageColorsScreen({super.key});

  @override
  State<ManageColorsScreen> createState() => _ManageColorsScreenState();
}

class _ManageColorsScreenState
    extends BaseManageScreenState<model.Color, ManageColorsScreen> {
  ColorProvider get _colorProvider =>
      Provider.of<ColorProvider>(context, listen: false);

  @override
  String getScreenTitle() => 'Color Management';

  @override
  int getSelectedIndex() => 6;

  @override
  String getEntityName() => 'color';

  @override
  IconData getEmptyStateIcon() => Icons.palette_outlined;

  @override
  String getSearchHint() => 'Search Color...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _colorProvider.fetchColors();
    });
  }

  @override
  void refreshData() {
    _colorProvider.fetchColors();
  }

  @override
  List<model.Color> getItems() {
    return context.watch<ColorProvider>().colors;
  }

  @override
  bool isLoading() {
    return context.watch<ColorProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditColorScreen()),
    );
  }

  @override
  Future<void> navigateToEdit(model.Color item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditColorScreen(entity: item)),
    );
  }

  @override
  Future<void> handleDelete(model.Color item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete color "${item.colorName}"?',
    );

    if (confirmed && mounted) {
      await _colorProvider.removeColor(item.id as int);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted "${item.colorName}"')));
      }
    }
  }

  @override
  Widget buildLeadingWidget(model.Color item) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
      ),
      child: Icon(
        Icons.palette_outlined,
        color: AppTheme.primaryBlack,
        size: 20,
      ),
    );
  }

  @override
  String getItemTitle(model.Color item) => item.colorName;

  @override
  Widget? buildSubtitle(model.Color item) {
    return StatusBadge(label: item.status);
  }

  @override
  Widget buildList() {
    final items = getItems();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AdminListItem(
          leading: buildLeadingWidget(item),
          title: getItemTitle(item),
          subtitle: buildSubtitle(item),
          onEdit: () => navigateToEdit(item),
          onDelete: () => handleDelete(item),
          editTooltip: 'Edit Color',
          deleteTooltip: 'Delete Color',
        );
      },
    );
  }
}
