import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart'
    as model; // Alias to avoid conflict with Material.Size
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';
import 'edit_size_screen.dart';

class ManageSizesScreen extends StatefulWidget {
  const ManageSizesScreen({super.key});

  @override
  State<ManageSizesScreen> createState() => _ManageSizesScreenState();
}

class _ManageSizesScreenState extends State<ManageSizesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch sizes when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SizeProvider>(context, listen: false).fetchSizes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Size Management',
      selectedIndex: 5,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<SizeProvider>(context, listen: false).fetchSizes();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddSize,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<SizeProvider>(
              builder: (context, sizeProvider, child) {
                if (sizeProvider.isLoading && sizeProvider.sizes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (sizeProvider.sizes.isEmpty) {
                  return const Center(child: Text('No sizes found.'));
                }
                return _buildListView(sizeProvider.sizes);
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
          hintText: 'Search Size...',
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

  Widget _buildListView(List<model.Size> sizes) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final s = sizes[index];
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
                borderRadius: AppTheme.borderRadiusSM,
                border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
              ),
              child: Center(
                child: Text(
                  s.sizeName.substring(0, 1).toUpperCase(),
                  style: AppTheme.h4.copyWith(fontSize: 16),
                ),
              ),
            ),
            title: Text(s.sizeName, style: AppTheme.h4.copyWith(fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                s.status,
                style: AppTheme.bodySmall.copyWith(
                  color: s.status == 'active' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
                  tooltip: 'Edit Size',
                  splashRadius: 20,
                  onPressed: () async {
                    final updatedSize = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditSizeScreen(size: s),
                      ),
                    );

                    if (updatedSize != null) {
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
                  tooltip: 'Delete Size',
                  splashRadius: 20,
                  onPressed: () => _onDeleteSize(s),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddSize() async {
    final newSize = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditSizeScreen()),
    );
  }

  Future<void> _onDeleteSize(model.Size size) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirm'),
        content: Text(
          'Are you sure you want to delete size "${size.sizeName}"?',
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
      Provider.of<SizeProvider>(
        context,
        listen: false,
      ).removeSize(size.id as int);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa "${size.sizeName}"')));
    }
  }
}
