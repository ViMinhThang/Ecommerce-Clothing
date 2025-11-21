import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart'
    as model; // Alias to avoid conflict with Material.Color
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';
import 'edit_color_screen.dart';

class ManageColorsScreen extends StatefulWidget {
  const ManageColorsScreen({super.key});

  @override
  State<ManageColorsScreen> createState() => _ManageColorsScreenState();
}

class _ManageColorsScreenState extends State<ManageColorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch colors when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColorProvider>(context, listen: false).fetchColors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Color Management',
      selectedIndex: 6, // This will be updated later in admin_drawer.dart
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<ColorProvider>(context, listen: false).fetchColors();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddColor,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<ColorProvider>(
              builder: (context, colorProvider, child) {
                if (colorProvider.isLoading && colorProvider.colors.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (colorProvider.colors.isEmpty) {
                  return const Center(child: Text('No colors found.'));
                }
                return _buildListView(colorProvider.colors);
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
          hintText: 'Search Color...',
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.lightGray),
          border: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: AppTheme.borderThin.top,
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

  Widget _buildListView(List<model.Color> colors) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final c = colors[index];
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
            ),
            title: Text(c.colorName, style: AppTheme.h4.copyWith(fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                c.status,
                style: AppTheme.bodySmall.copyWith(
                  color: c.status == 'active' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
                  tooltip: 'Edit Color',
                  splashRadius: 20,
                  onPressed: () async {
                    final updatedColor = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditColorScreen(color: c),
                      ),
                    );

                    if (updatedColor != null) {
                      // The provider will handle updating its internal list and notifying listeners
                      // No need to call setState here directly on the list
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF5350),
                  ),
                  tooltip: 'Delete Color',
                  splashRadius: 20,
                  onPressed: () => _onDeleteColor(c),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddColor() async {
    final newColor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditColorScreen()),
    );
  }

  Future<void> _onDeleteColor(model.Color color) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirm'),
        content: Text(
          'Are you sure you want to delete color "${color.colorName}"?',
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
      Provider.of<ColorProvider>(
        context,
        listen: false,
      ).removeColor(color.id as int);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa "${color.colorName}"')));
    }
  }
}
