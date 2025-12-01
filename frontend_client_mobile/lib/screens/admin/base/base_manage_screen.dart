import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../widgets/shared/admin_search_bar.dart';
import '../../../widgets/shared/empty_state_widget.dart';

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

  /// Build the leading widget for list item
  Widget buildLeadingWidget(T item);

  /// Get the title text from item
  String getItemTitle(T item);

  /// Build the subtitle widget for list item (optional)
  Widget? buildSubtitle(T item);

  // Template method - defines the structure
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: getScreenTitle(),
      selectedIndex: getSelectedIndex(),
      actions: [
        IconButton(onPressed: refreshData, icon: const Icon(Icons.refresh)),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        AdminSearchBar(
          hintText: getSearchHint(),
          controller: searchController,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 16),
        Expanded(child: buildContent()),
      ],
    );
  }

  Widget buildContent() {
    if (isLoading() && getItems().isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (getItems().isEmpty) {
      return EmptyStateWidget(
        message: 'No ${getEntityName()}s found.',
        icon: getEmptyStateIcon(),
      );
    }

    return buildList();
  }

  Widget buildList();

  /// Hook for search functionality
  void onSearchChanged(String query) {
    // Default: do nothing, subclasses can override
  }
}
