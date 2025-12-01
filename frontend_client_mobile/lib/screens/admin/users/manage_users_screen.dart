import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/status_badge.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_user_screen.dart';

class ManageUsersScreen extends BaseManageScreen<Map<String, dynamic>> {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends BaseManageScreenState<Map<String, dynamic>, ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];

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
    _loadMockData();
  }

  @override
  void refreshData() {
    setState(() => _loadMockData());
  }

  void _loadMockData() {
    _users = [
      {
        'id': 1,
        'name': 'Nguyễn Văn A',
        'email': 'vana@example.com',
        'role': 'Admin',
        'status': 'active',
      },
      {
        'id': 2,
        'name': 'Trần Thị B',
        'email': 'thib@example.com',
        'role': 'User',
        'status': 'inactive',
      },
    ];
  }

  @override
  List<Map<String, dynamic>> getItems() => _users;

  @override
  bool isLoading() => false;

  @override
  Future<void> navigateToAdd() async {
    final newUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditUserScreen()),
    );
    if (newUser != null && mounted) {
      setState(() => _users.add(newUser));
    }
  }

  @override
  Future<void> navigateToEdit(Map<String, dynamic> item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditUserScreen(entity: item)),
    );

    if (updated != null && mounted) {
      setState(() {
        final index = _users.indexWhere((u) => u['id'] == updated['id']);
        if (index != -1) _users[index] = updated;
      });
    }
  }

  @override
  Future<void> handleDelete(Map<String, dynamic> item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete user "${item['name']}"?',
    );

    if (confirmed && mounted) {
      setState(() {
        _users.removeWhere((u) => u['id'] == item['id']);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted "${item['name']}"')));
    }
  }

  @override
  Widget buildLeadingWidget(Map<String, dynamic> item) {
    return CircleAvatar(
      backgroundColor: AppTheme.offWhite,
      radius: 24,
      child: Text(
        item['name'].toString().substring(0, 1).toUpperCase(),
        style: AppTheme.h4.copyWith(fontSize: 18),
      ),
    );
  }

  @override
  String getItemTitle(Map<String, dynamic> item) => item['name'];

  @override
  Widget? buildSubtitle(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['email'],
          style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            StatusBadge(label: item['role'], type: StatusBadgeType.userRole),
            const SizedBox(width: 8),
            StatusBadge(
              label: item['status'],
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
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AdminListItem(
          leading: buildLeadingWidget(item),
          title: getItemTitle(item),
          subtitle: buildSubtitle(item),
          onEdit: () => navigateToEdit(item),
          onDelete: () => handleDelete(item),
          editTooltip: 'Edit User',
          deleteTooltip: 'Delete User',
        );
      },
    );
  }
}
