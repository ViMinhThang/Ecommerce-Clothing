import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/admin/admin_drawer.dart';
import '../../../widgets/shared/admin_search_bar.dart';
import '../../../widgets/shared/empty_state_widget.dart';

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

  String getScreenTitle();

  int getSelectedIndex();

  String getEntityName();

  IconData getEmptyStateIcon();

  String getSearchHint();

  void fetchData();

  void refreshData();

  List<T> getItems();

  bool isLoading();

  Future<void> navigateToAdd();

  Future<void> navigateToEdit(T item);

  Future<void> handleDelete(T item);

  List<Widget> buildHeaderWidgets() => [];

  Widget buildSearchSection() => AdminSearchBar(
    hintText: getSearchHint(),
    controller: searchController,
    onChanged: onSearchChanged,
  );

  Widget buildList();

  ScrollController? getScrollController() => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: AdminDrawer(selectedIndex: getSelectedIndex()),
      body: CustomScrollView(
        controller: getScrollController(),
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
              child: Builder(
                builder: (context) {
                  final headerWidgets = buildHeaderWidgets();
                  return Column(
                    children: [
                      ...headerWidgets,
                      if (headerWidgets.isNotEmpty) const SizedBox(height: 16),
                      buildSearchSection(),
                    ],
                  );
                },
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

  void onSearchChanged(String query) {}
}
