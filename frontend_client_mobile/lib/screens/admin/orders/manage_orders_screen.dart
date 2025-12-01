import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_config.dart';
import '../../../layouts/admin_layout.dart';
import '../../../models/order_view.dart';
import '../../../providers/order_provider.dart';
import '../../../utils/dialogs.dart';
import 'edit_order_screen.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedSort = _SortOption.defaults.first.id;
  String _selectedStatus = _StatusOption.defaults.first.id;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleInfiniteScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleInfiniteScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Order Management',
      selectedIndex: 5,
      actions: [
        IconButton(
          onPressed: () => context.read<OrderProvider>().refreshAll(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _handleCreateOrder(context.read<OrderProvider>()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Consumer<OrderProvider>(
          builder: (context, provider, _) {
            final visibleOrders = _filterOrders(provider.orders);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildControls(provider),
                const SizedBox(height: 16),
                _buildStatistics(provider),
                const SizedBox(height: 16),
                Expanded(child: _buildListView(provider, visibleOrders)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(OrderProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatusDropdown(provider)),
            const SizedBox(width: 12),
            Expanded(child: _buildSortDropdown(provider)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics(OrderProvider provider) {
    final stats = provider.statistics;
    final isLoading = provider.isLoadingStatistics;

    if (isLoading && stats == null) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: AppTheme.borderRadiusMD,
          border: AppTheme.borderThin,
          boxShadow: AppTheme.shadowSM,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (stats == null) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: AppTheme.borderRadiusMD,
          border: AppTheme.borderThin,
          boxShadow: AppTheme.shadowSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chưa có dữ liệu thống kê',
              style: AppTheme.h4.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn "Tải lại" để đồng bộ dữ liệu thống kê từ API.',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: provider.fetchStatistics,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      );
    }

    final cards = [
      _StatCardData(
        title: 'Hôm nay',
        periodLabel: 'Theo ngày',
        orders: stats.totalOrderByDay,
        revenue: stats.totalPriceByDay,
        icon: Icons.today_outlined,
        accent: const Color(0xFF1E88E5),
      ),
      _StatCardData(
        title: 'Tuần này',
        periodLabel: '7 ngày gần nhất',
        orders: stats.totalOrderByWeek,
        revenue: stats.totalPriceByWeek,
        icon: Icons.calendar_view_week,
        accent: const Color(0xFF43A047),
      ),
      _StatCardData(
        title: 'Tháng này',
        periodLabel: '30 ngày gần nhất',
        orders: stats.totalOrderByMonth,
        revenue: stats.totalPriceByMonth,
        icon: Icons.calendar_today_outlined,
        accent: const Color(0xFFFB8C00),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
            child: Row(
              children: [
                Text(
                  'Thống kê nhanh',
                  style: AppTheme.h4.copyWith(fontSize: 16),
                ),
                const SizedBox(width: 8),
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Làm mới thống kê',
                  splashRadius: 18,
                  onPressed: provider.fetchStatistics,
                  icon: const Icon(Icons.refresh, size: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 88,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _StatisticChip(data: cards[index]),
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
          hintText: 'Search Order...',
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
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildStatusDropdown(OrderProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: _dropdownDecoration('Status'),
      items: _StatusOption.defaults
          .map(
            (status) => DropdownMenuItem(
              value: status.id,
              child: Text(status.label, style: AppTheme.bodyMedium),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedStatus = value);
        final selected = _StatusOption.defaults.firstWhere(
          (element) => element.id == value,
        );
        provider.updateFilters(status: selected.status, applyStatus: true);
      },
    );
  }

  Widget _buildSortDropdown(OrderProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedSort,
      decoration: _dropdownDecoration('Sort'),
      items: _SortOption.defaults
          .map(
            (option) => DropdownMenuItem(
              value: option.id,
              child: Text(option.label, style: AppTheme.bodyMedium),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedSort = value);
        final selected = _SortOption.defaults.firstWhere(
          (element) => element.id == value,
        );
        provider.updateFilters(
          sortBy: selected.sortBy,
          direction: selected.direction,
        );
      },
    );
  }

  InputDecoration _dropdownDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
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
      borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1.5),
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  );

  Widget _buildListView(OrderProvider provider, List<OrderView> data) {
    if (provider.isLoading && provider.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.refreshAll,
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    color: AppTheme.mediumGray,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Không có đơn hàng nào',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshAll,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: data.length,
        itemBuilder: (context, index) => _OrderTile(
          order: data[index],
          onEdit: () => _handleEditOrder(provider, data[index]),
          onDelete: () => _handleDeleteOrder(provider, data[index]),
        ),
      ),
    );
  }

  List<OrderView> _filterOrders(List<OrderView> source) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source
        .where(
          (order) =>
              order.id.toString().contains(query) ||
              order.buyerEmail.toLowerCase().contains(query) ||
              order.status.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _handleCreateOrder(OrderProvider provider) async {
    final payload = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const EditOrderScreen()),
    );
    if (payload == null) return;

    try {
      await provider.createOrder(_mapFormToOrder(payload));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tạo đơn hàng thành công')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể tạo đơn hàng: $error')));
    }
  }

  Future<void> _handleEditOrder(OrderProvider provider, OrderView order) async {
    final payload = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditOrderScreen(order: _mapOrderToForm(order)),
      ),
    );
    if (payload == null) return;

    try {
      await provider.updateOrder(_mapFormToOrder(payload));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã cập nhật đơn hàng')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật đơn hàng: $error')),
      );
    }
  }

  Future<void> _handleDeleteOrder(
    OrderProvider provider,
    OrderView order,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Confirm',
      message: 'Bạn có chắc muốn xóa đơn #${order.id}?',
    );
    if (!confirmed) return;

    try {
      await provider.deleteOrder(order.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa đơn hàng #${order.id}')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể xóa đơn hàng: $error')));
    }
  }

  Map<String, dynamic> _mapOrderToForm(OrderView order) => {
    'id': order.id,
    'customer': order.buyerEmail,
    'total': order.totalPrice,
    'date': order.createdDate,
    'status': order.status,
  };

  OrderView _mapFormToOrder(Map<String, dynamic> data) => OrderView(
    id: (data['id'] as int?) ?? 0,
    buyerEmail: (data['customer'] as String?)?.trim() ?? '',
    totalPrice: (data['total'] as num?)?.toDouble() ?? 0,
    createdDate: (data['date'] as String?) ?? '',
    status: (data['status'] as String?) ?? 'pending',
  );

  void _handleInfiniteScroll() {
    if (!_scrollController.hasClients) return;
    final provider = context.read<OrderProvider>();
    final trigger = _scrollController.position.extentAfter < 200;
    if (trigger && provider.hasMore && !provider.isLoading) {
      provider.fetchNextPage();
    }
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return AppTheme.mediumGray;
    }
  }

  static String _shortId(int id) {
    final value = id.toString();
    if (value.length <= 2) return value.padLeft(2, '0');
    return value.substring(value.length - 2);
  }

  static String _formatCurrency(double value) {
    final digits = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return buffer.toString();
  }

  static String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final two = (int v) => v.toString().padLeft(2, '0');
    return '${parsed.year}-${two(parsed.month)}-${two(parsed.day)}';
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({
    required this.order,
    required this.onEdit,
    required this.onDelete,
  });

  final OrderView order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlack,
            shape: BoxShape.circle,
            boxShadow: AppTheme.shadowSM,
          ),
          child: Center(
            child: Text(
              '#${_ManageOrdersScreenState._shortId(order.id)}',
              style: AppTheme.h4.copyWith(
                color: AppTheme.primaryWhite,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          order.buyerEmail.isEmpty ? 'Unknown Customer' : order.buyerEmail,
          style: AppTheme.h4.copyWith(fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₫${_ManageOrdersScreenState._formatCurrency(order.totalPrice)} • ${_ManageOrdersScreenState._formatDate(order.createdDate)}',
                style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _ManageOrdersScreenState._getStatusColor(
                    order.status,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _ManageOrdersScreenState._getStatusColor(
                      order.status,
                    ).withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: AppTheme.bodySmall.copyWith(
                    color: _ManageOrdersScreenState._getStatusColor(
                      order.status,
                    ),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
              tooltip: 'Edit Order',
              splashRadius: 20,
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
              tooltip: 'Delete Order',
              splashRadius: 20,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption {
  const _SortOption({
    required this.id,
    required this.label,
    required this.sortBy,
    required this.direction,
  });

  final String id;
  final String label;
  final String sortBy;
  final String direction;

  static const defaults = <_SortOption>[
    _SortOption(
      id: 'created_desc',
      label: 'Mới nhất',
      sortBy: 'createdDate',
      direction: 'DESC',
    ),
    _SortOption(
      id: 'created_asc',
      label: 'Cũ nhất',
      sortBy: 'createdDate',
      direction: 'ASC',
    ),
    _SortOption(
      id: 'total_desc',
      label: 'Giá cao → thấp',
      sortBy: 'totalPrice',
      direction: 'DESC',
    ),
    _SortOption(
      id: 'total_asc',
      label: 'Giá thấp → cao',
      sortBy: 'totalPrice',
      direction: 'ASC',
    ),
  ];
}

class _StatusOption {
  const _StatusOption({
    required this.id,
    required this.label,
    required this.status,
  });

  final String id;
  final String label;
  final String? status;

  static const defaults = <_StatusOption>[
    _StatusOption(id: 'all', label: 'Tất cả trạng thái', status: null),
    _StatusOption(id: 'pending', label: 'Pending', status: 'pending'),
    _StatusOption(id: 'processing', label: 'Processing', status: 'processing'),
    _StatusOption(id: 'completed', label: 'Completed', status: 'completed'),
    _StatusOption(id: 'cancelled', label: 'Cancelled', status: 'cancelled'),
  ];
}

class _StatCardData {
  const _StatCardData({
    required this.title,
    required this.periodLabel,
    required this.orders,
    required this.revenue,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String periodLabel;
  final int orders;
  final double revenue;
  final IconData icon;
  final Color accent;
}

class _StatisticChip extends StatelessWidget {
  const _StatisticChip({required this.data});

  final _StatCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: data.accent.withOpacity(0.06),
        borderRadius: AppTheme.borderRadiusMD,
        border: Border.all(color: data.accent.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${data.orders} đơn',
                  style: AppTheme.h4.copyWith(fontSize: 16),
                ),
                Text(
                  '₫${_ManageOrdersScreenState._formatCurrency(data.revenue)}',
                  style: AppTheme.bodySmall.copyWith(color: data.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
