import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as model;
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
    extends BaseManageScreenState<model.Color, ManageColorsScreen>
    with SingleTickerProviderStateMixin {
  ColorProvider get _colorProvider =>
      Provider.of<ColorProvider>(context, listen: false);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  String getScreenTitle() => 'Product Colors';

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
      _colorProvider.fetchColors().then((_) {
        if (mounted) _animationController.forward(from: 0);
      });
    });
  }

  @override
  void refreshData() {
    _colorProvider.fetchColors().then((_) {
      if (mounted) _animationController.forward(from: 0);
    });
  }

  @override
  void onSearchChanged(String query) {
    _colorProvider.searchColors(query);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${item.colorName}"'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.primaryBlack,
          ),
        );
      }
    }
  }

  Widget _buildLeadingWidget(model.Color item) {
    Color? circleColor;
    if (item.colorCode != null && item.colorCode!.isNotEmpty) {
      try {
        final hexString = item.colorCode!.replaceAll('#', '');
        circleColor = Color(int.parse('FF$hexString', radix: 16));
      } catch (e) {
        circleColor = null;
      }
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: circleColor ?? Colors.black,
        borderRadius: AppTheme.borderRadiusXS,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: circleColor == null
          ? const Center(
              child: Icon(
                Icons.palette_outlined,
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
    );
  }

  String _getItemTitle(model.Color item) => item.colorName.toUpperCase();

  Widget? _buildSubtitle(model.Color item) {
    return Row(
      children: [
        StatusBadge(label: item.status),
        const SizedBox(width: 8),
        Text(
          item.colorCode ?? '#??????',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildList() {
    final items = getItems();

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
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
              editTooltip: 'Edit Color',
              deleteTooltip: 'Delete Color',
            ),
          ),
        );
      },
    );
  }
}
