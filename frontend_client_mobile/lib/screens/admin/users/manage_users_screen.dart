import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/user_item_view.dart';
import 'package:frontend_client_mobile/models/user_search_result.dart';
import 'package:frontend_client_mobile/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/admin_search_bar.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../../../widgets/shared/status_badge.dart';
import '../base/base_manage_screen.dart';
import 'create_user_screen.dart';
import 'edit_user_screen.dart';
import 'user_detail_screen.dart';

class ManageUsersScreen extends BaseManageScreen<UserItemView> {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends BaseManageScreenState<UserItemView, ManageUsersScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  bool _showSuggestions = false;
  late FocusNode _searchFocusNode;
  Timer? _searchDebounce;
  late AnimationController _animationController;

  @override
  void initState() {
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(_handleFocusChange);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode.removeListener(_handleFocusChange);
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  String getScreenTitle() => 'User Management';

  @override
  int getSelectedIndex() => 3;

  @override
  String getEntityName() => 'user';

  @override
  IconData getEmptyStateIcon() => Icons.people_outline;

  @override
  String getSearchHint() => 'Search User...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UserProvider>().initialize().then((_) {
        if (mounted) _animationController.forward(from: 0);
      });
    });
  }

  @override
  void refreshData() {
    context.read<UserProvider>().refreshUsers().then((_) {
      if (mounted) _animationController.forward(from: 0);
    });
  }

  @override
  List<UserItemView> getItems() {
    final users = context.watch<UserProvider>().users;
    if (_searchQuery.trim().isEmpty) return users;
    final keyword = _searchQuery.toLowerCase();
    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(keyword) ||
              (user.email ?? '').toLowerCase().contains(keyword),
        )
        .toList();
  }

  @override
  bool isLoading() => context.watch<UserProvider>().isLoading;

  @override
  Future<void> navigateToAdd() async {
    final newUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateUserScreen()),
    );
    if (newUser != null && mounted) {
      context.read<UserProvider>().refreshUsers();
    }
  }

  @override
  Future<void> navigateToEdit(UserItemView item) async {
    final payload = {
      'id': item.id,
      'name': item.name,
      'email': item.email,
      'role': item.roles.join(', '),
      'status': item.status,
    };
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditUserScreen(entity: payload)),
    );

    if (updated != null && mounted) {
      context.read<UserProvider>().refreshUsers();
    }
  }

  @override
  Future<void> handleDelete(UserItemView item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete user "${item.name}"?',
    );

    if (confirmed && mounted) {
      await context.read<UserProvider>().deleteUser(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted "${item.name}"')));
    }
  }

  Widget _buildLeadingWidget(UserItemView item) {
    // Generate a consistent color based on the user's name
    final nameHash = item.name.hashCode;
    final primaryColor = Colors.primaries[nameHash % Colors.primaries.length];

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: AppTheme.borderRadiusXS,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor.withValues(alpha: 0.8), primaryColor],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        item.name.substring(0, 1).toUpperCase(),
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _getItemTitle(UserItemView item) => item.name;

  Widget? _buildSubtitle(UserItemView item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.email ?? 'NO EMAIL',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black45,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            StatusBadge(
              label: item.roles.isEmpty ? 'USER' : item.roles.first,
              type: StatusBadgeType.userRole,
            ),
            const SizedBox(width: 6),
            StatusBadge(
              label: item.status,
              type: StatusBadgeType.activeInactive,
            ),
          ],
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
            (index * 0.08).clamp(0, 1.0),
            ((index * 0.08) + 0.4).clamp(0, 1.0),
            curve: Curves.easeOutQuart,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: AdminListItem(
              leading: _buildLeadingWidget(item),
              title: _getItemTitle(item),
              subtitle: _buildSubtitle(item),
              onTap: () => _openUserDetail(item.id, fallbackName: item.name),
              onEdit: () => navigateToEdit(item),
              onDelete: () => handleDelete(item),
              editTooltip: 'Edit User',
              deleteTooltip: 'Delete User',
            ),
          ),
        );
      },
    );
  }

  @override
  void onSearchChanged(String query) => _handleSearchInput(query);

  @override
  Widget buildSearchSection() {
    final provider = context.watch<UserProvider>();
    final suggestions = provider.searchResults;
    final showDropdown =
        _showSuggestions &&
        (provider.isSearching || suggestions.isNotEmpty) &&
        _searchFocusNode.hasFocus;

    return Column(
      children: [
        AdminSearchBar(
          hintText: getSearchHint(),
          controller: searchController,
          onChanged: onSearchChanged,
          focusNode: _searchFocusNode,
        ),
        if (showDropdown)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: provider.isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : suggestions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'No matches',
                      style: TextStyle(color: AppTheme.mediumGray),
                    ),
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.person_outline, size: 20),
                          title: Text(suggestion.fullName),
                          subtitle: suggestion.email != null
                              ? Text(
                                  suggestion.email!,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.mediumGray,
                                  ),
                                )
                              : null,
                          onTap: () => _onSuggestionTap(suggestion),
                        );
                      },
                    ),
                  ),
          ),
      ],
    );
  }

  void _handleSearchInput(String query) {
    final trimmed = query.trim();
    setState(() {
      _searchQuery = query;
      _showSuggestions = trimmed.isNotEmpty && _searchFocusNode.hasFocus;
    });

    _searchDebounce?.cancel();
    if (trimmed.isEmpty) {
      context.read<UserProvider>().searchUsers('');
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<UserProvider>().searchUsers(trimmed);
    });
  }

  void _handleFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() => _showSuggestions = false);
    } else if (searchController.text.trim().isNotEmpty) {
      setState(() => _showSuggestions = true);
    }
  }

  void _onSuggestionTap(UserSearchResult suggestion) {
    _searchDebounce?.cancel();
    searchController.text = suggestion.fullName;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );
    context.read<UserProvider>().searchUsers('');
    setState(() {
      _searchQuery = suggestion.fullName;
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
    _openUserDetail(suggestion.id, fallbackName: suggestion.fullName);
  }

  void _openUserDetail(int id, {String? fallbackName}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(userId: id, initialName: fallbackName),
      ),
    );
  }
}
