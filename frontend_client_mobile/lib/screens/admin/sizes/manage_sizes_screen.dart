import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart'
    as model; // Alias to avoid conflict with Material.Size
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
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
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search Size...',
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

  Widget _buildListView(List<model.Size> sizes) {
    return ListView.builder(
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final s = sizes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              s.sizeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              s.status, // Assuming status can be used as a subtitle
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit Size',
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Size',
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
