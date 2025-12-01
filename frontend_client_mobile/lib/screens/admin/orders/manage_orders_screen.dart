import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/status_badge.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';
import 'edit_order_screen.dart';

class ManageOrdersScreen extends BaseManageScreen<Map<String, dynamic>> {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState
    extends BaseManageScreenState<Map<String, dynamic>, ManageOrdersScreen> {
  List<Map<String, dynamic>> _orders = [];

  @override
  String getScreenTitle() => 'Order Management';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'order';

  @override
  IconData getEmptyStateIcon() => Icons.shopping_cart_outlined;

  @override
  String getSearchHint() => 'Search Order...';

  @override
  void fetchData() {
    _loadMockData();
  }

  @override
  void refreshData() {
    setState(() => _loadMockData());
  }

  void _loadMockData() {
    _orders = [
      {
        'id': 1001,
        'customer': 'Nguyễn Văn A',
        'total': 599000,
        'date': '2025-10-30',
        'status': 'pending',
      },
      {
        'id': 1002,
        'customer': 'Trần Thị B',
        'total': 1299000,
        'date': '2025-10-29',
        'status': 'completed',
      },
    ];
  }

  @override
  List<Map<String, dynamic>> getItems() => _orders;

  @override
  bool isLoading() => false;

  @override
  Future<void> navigateToAdd() async {
    final newOrder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditOrderScreen()),
    );
    if (newOrder != null && mounted) {
      setState(() => _orders.add(newOrder));
    }
  }

  @override
  Future<void> navigateToEdit(Map<String, dynamic> item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditOrderScreen(entity: item)),
    );

    if (updated != null && mounted) {
      setState(() {
        final index = _orders.indexWhere((o) => o['id'] == updated['id']);
        if (index != -1) _orders[index] = updated;
      });
    }
  }

  @override
  Future<void> handleDelete(Map<String, dynamic> item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete order #${item['id']}?',
    );

    if (confirmed && mounted) {
      setState(() {
        _orders.removeWhere((o) => o['id'] == item['id']);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted order #${item['id']}')));
    }
  }

  @override
  Widget buildLeadingWidget(Map<String, dynamic> item) {
    final orderId = item['id'].toString();
    final lastTwo = orderId.substring(orderId.length - 2);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        shape: BoxShape.circle,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Center(
        child: Text(
          '#$lastTwo',
          style: AppTheme.h4.copyWith(
            color: AppTheme.primaryWhite,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  String getItemTitle(Map<String, dynamic> item) => item['customer'];

  @override
  Widget? buildSubtitle(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₫${item['total']} • ${item['date']}',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
        ),
        const SizedBox(height: 4),
        StatusBadge(label: item['status'], type: StatusBadgeType.orderStatus),
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
          editTooltip: 'Edit Order',
          deleteTooltip: 'Delete Order',
        );
      },
    );
  }
}
