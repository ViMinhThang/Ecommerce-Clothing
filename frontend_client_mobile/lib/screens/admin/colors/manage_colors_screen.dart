import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart'
    as model; // Alias to avoid conflict with Material.Color
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
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
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search Color...',
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
        // Filter logic will go here when API is integrated
      },
    );
  }

  Widget _buildListView(List<model.Color> colors) {
    return ListView.builder(
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final c = colors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              c.colorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              c.status, // Assuming status can be used as a subtitle
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit Color',
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Color',
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
