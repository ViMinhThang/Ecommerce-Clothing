import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_search_bar.dart';
import '../../../widgets/shared/empty_state_widget.dart';
import '../../../widgets/admin/admin_drawer.dart';

/// Abstract base class for all management screens following Template Method pattern
///
/// This class provides the common structure and behavior for list-based management
/// screens (Color, Size, Category, Order, User management).
///
/// Subclasses must implement abstract methods to provide entity-specific behavior.
abstract class BaseManageScreen<T> extends StatefulWidget {
  const BaseManageScreen({super.key});
}

abstract class BaseManageScreenState<T, S extends BaseManageScreen<T>>
    extends State<S> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Abstract methods to be implemented by subclasses

  /// Return the screen title (e.g., "Color Management")
  String getScreenTitle();

  /// Return the selected index for navigation drawer
  int getSelectedIndex();

  /// Return the entity name for messages (e.g., "color", "size")
  String getEntityName();

  /// Return the icon to display in empty state
  IconData getEmptyStateIcon();

  /// Return the search hint text (e.g., "Search Color...")
  String getSearchHint();

  /// Fetch data from provider/service
  void fetchData();

  /// Refresh data
  void refreshData();

  /// Get the list of items to display
  List<T> getItems();

  /// Check if data is currently loading
  bool isLoading();

  /// Navigate to add screen
  Future<void> navigateToAdd();

  /// Navigate to edit screen
  Future<void> navigateToEdit(T item);

  /// Handle delete action
  Future<void> handleDelete(T item);

  /// Build optional header widgets to display before the list (e.g., stats)
  List<Widget> buildHeaderWidgets() => [];

  /// Build the list widget (must return a Sliver, e.g., SliverList)
  Widget buildList();

  // Template method - defines the structure
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: AdminDrawer(selectedIndex: getSelectedIndex()),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              getScreenTitle(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            backgroundColor: AppTheme.background,
            surfaceTintColor: Colors.transparent,
            iconTheme: const IconThemeData(color: AppTheme.primaryBlack),
            actions: [
              IconButton(
                onPressed: refreshData,
                icon: const Icon(Icons.refresh),
              ),
            ],
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  ...buildHeaderWidgets(),
                  if (buildHeaderWidgets().isNotEmpty)
                    const SizedBox(height: 16),
                  AdminSearchBar(
                    hintText: getSearchHint(),
                    controller: searchController,
                    onChanged: onSearchChanged,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        backgroundColor: Colors.black,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildContent() {
    if (isLoading() && getItems().isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (getItems().isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateWidget(
          message: 'No ${getEntityName()}s found.',
          icon: getEmptyStateIcon(),
        ),
      );
    }

    return buildList();
  }

  /// Hook for search functionality
  void onSearchChanged(String query) {
    // Default: do nothing, subclasses can override
  }
}
