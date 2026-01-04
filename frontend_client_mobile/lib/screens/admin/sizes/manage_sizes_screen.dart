import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
    extends BaseManageScreenState<model.Size, ManageSizesScreen>
    with SingleTickerProviderStateMixin {
  SizeProvider get _sizeProvider =>
      Provider.of<SizeProvider>(context, listen: false);

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
  String getScreenTitle() => 'Product Sizes';

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
      _sizeProvider.fetchSizes().then((_) {
        if (mounted) _animationController.forward(from: 0);
      });
    });
  }

  @override
  void refreshData() {
    _sizeProvider.fetchSizes().then((_) {
      if (mounted) _animationController.forward(from: 0);
    });
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${item.sizeName}"'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.primaryBlack,
          ),
        );
      }
    }
  }

  Widget _buildLeadingWidget(model.Size item) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: AppTheme.borderRadiusXS,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Text(
          item.sizeName.substring(0, 1).toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  String _getItemTitle(model.Size item) => item.sizeName.toUpperCase();

  Widget? _buildSubtitle(model.Size item) {
    return Row(
      children: [
        StatusBadge(label: item.status),
        const SizedBox(width: 8),
        Text(
          'ID: ${item.id}',
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
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
              editTooltip: 'Edit Size',
              deleteTooltip: 'Delete Size',
            ),
          ),
        );
      },
    );
  }
}
