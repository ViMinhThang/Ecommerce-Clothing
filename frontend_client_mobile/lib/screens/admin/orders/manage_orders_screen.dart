import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _ManageOrdersScreenState extends State<ManageOrdersScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String selectedSort = _SortOption.defaults.first.id;
  String selectedStatus = _StatusOption.defaults.first.id;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    scrollController.addListener(_handleInfiniteScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderProvider>().initialize();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController
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
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
        ),
      );
    }

    if (stats == null) {
      return Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'REVENUE TRACKER UNAVAILABLE',
              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: provider.fetchStatistics,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: Text(
                'SYNC DATA',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final cards = [
      _StatCardData(
        Icons.shopping_bag_outlined,
        'Today Orders',
        stats.totalOrderByDay.toString(),
        const Color(0xFF6366F1),
      ),
      _StatCardData(
        Icons.attach_money_outlined,
        'Today Revenue',
        '\$${stats.totalPriceByDay.toStringAsFixed(0)}',
        const Color(0xFF10B981),
      ),
      _StatCardData(
        Icons.calendar_today_outlined,
        'Week Orders',
        stats.totalOrderByWeek.toString(),
        const Color(0xFF3B82F6),
      ),
      _StatCardData(
        Icons.trending_up_outlined,
        'Week Revenue',
        '\$${stats.totalPriceByWeek.toStringAsFixed(0)}',
        const Color(0xFFF59E0B),
      ),
      _StatCardData(
        Icons.calendar_month_outlined,
        'Month Orders',
        stats.totalOrderByMonth.toString(),
        const Color(0xFF8B5CF6),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'LIVE ANALYTICS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.black,
                ),
              )
            else
              GestureDetector(
                onTap: provider.fetchStatistics,
                child: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: Colors.black26,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final animation = CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  (index * 0.1).clamp(0, 0.4),
                  (0.4 + (index * 0.1)).clamp(0, 1.0),
                  curve: Curves.easeOut,
                ),
              );
              return ScaleTransition(
                scale: animation,
                child: _StatisticChip(data: cards[index]),
              );
            },
          ),
        ),
      ],
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
      initialValue: selectedStatus,
      decoration: _dropdownDecoration('STATUS'),
      icon: const Icon(Icons.tune_rounded, size: 18, color: Colors.black45),
      items: _StatusOption.defaults
          .map(
            (status) => DropdownMenuItem(
              value: status.id,
              child: Text(status.label, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => selectedStatus = value);
        final selected = _StatusOption.defaults.firstWhere(
          (element) => element.id == value,
        );
        provider.updateFilters(status: selected.status, applyStatus: true);
      },
    );
  }

  Widget _buildSortDropdown(OrderProvider provider) {
    return DropdownButtonFormField<String>(
      initialValue: selectedSort,
      decoration: _dropdownDecoration('SORT'),
      icon: const Icon(Icons.sort_rounded, size: 18, color: Colors.black45),
      items: _SortOption.defaults
          .map(
            (option) => DropdownMenuItem(
              value: option.id,
              child: Text(option.label, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => selectedSort = value);
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
    labelStyle: GoogleFonts.outfit(
      color: Colors.black38,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    ),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  Widget _buildListView(OrderProvider provider, List<OrderView> data) {
    if (provider.isLoading && provider.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.refreshAll,
        child: ListView(
          controller: scrollController,
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
        controller: scrollController,
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
    final result = await Navigator.push<OrderView?>(
      context,
      MaterialPageRoute(builder: (_) => const EditOrderScreen()),
    );
    if (result == null) return;

    try {
      await provider.createOrder(result);
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
      MaterialPageRoute(builder: (_) => EditOrderScreen(entity: order)),
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
      'Delete Confirm',
      'Bạn có chắc muốn xóa đơn #${order.id}?',
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

  OrderView _mapFormToOrder(Map<String, dynamic> data) => OrderView(
    id: (data['id'] as int?) ?? 0,
    buyerEmail: (data['customer'] as String?)?.trim() ?? '',
    totalPrice: (data['total'] as num?)?.toDouble() ?? 0,
    createdDate: (data['date'] as String?) ?? '',
    status: (data['status'] as String?) ?? 'pending',
  );

  void _handleInfiniteScroll() {
    if (!scrollController.hasClients) return;
    final provider = context.read<OrderProvider>();
    final trigger = scrollController.position.extentAfter < 200;
    if (trigger && provider.hasMore && !provider.isLoading) {
      provider.fetchNextPage();
    }
  }

  static String _shortId(int id) {
    final value = id.toString();
    if (value.length <= 2) return value.padLeft(2, '0');
    return value.substring(value.length - 2);
  }

  static String _formatCurrency(double value) {
    if (value == 0) return '0';
    final digits = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(parsed.day)}/${two(parsed.month)}/${parsed.year}';
  }
}

class _OrderTile extends StatelessWidget {
  final OrderView order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OrderTile({
    required this.order,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${_ManageOrdersScreenState._shortId(order.id)}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  order.buyerEmail,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 11,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _ManageOrdersScreenState._formatDate(order.createdDate),
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      '\$${_ManageOrdersScreenState._formatCurrency(order.totalPrice)}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: onEdit,
                tooltip: 'Edit',
                color: Colors.blue[700],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
                tooltip: 'Delete',
                color: Colors.red[700],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortOption {
  final String id;
  final String label;
  final String sortBy;
  final String direction;

  const _SortOption({
    required this.id,
    required this.label,
    required this.sortBy,
    required this.direction,
  });

  static const defaults = <_SortOption>[
    _SortOption(
      id: 'created_desc',
      label: 'Mới nhất',
      sortBy: 'createdDate',
      direction: 'desc',
    ),
    _SortOption(
      id: 'created_asc',
      label: 'Cũ nhất',
      sortBy: 'createdDate',
      direction: 'asc',
    ),
    _SortOption(
      id: 'price_desc',
      label: 'Giá cao nhất',
      sortBy: 'totalPrice',
      direction: 'desc',
    ),
    _SortOption(
      id: 'price_asc',
      label: 'Giá thấp nhất',
      sortBy: 'totalPrice',
      direction: 'asc',
    ),
  ];
}

class _StatusOption {
  final String id;
  final String label;
  final String? status;

  const _StatusOption({
    required this.id,
    required this.label,
    required this.status,
  });

  static const defaults = <_StatusOption>[
    _StatusOption(id: 'all', label: 'Tất cả trạng thái', status: null),
    _StatusOption(id: 'pending', label: 'Pending', status: 'pending'),
    _StatusOption(id: 'processing', label: 'Processing', status: 'processing'),
    _StatusOption(id: 'completed', label: 'Completed', status: 'completed'),
    _StatusOption(id: 'cancelled', label: 'Cancelled', status: 'cancelled'),
  ];
}

class _StatCardData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCardData(this.icon, this.label, this.value, this.color);
}

class _StatisticChip extends StatelessWidget {
  final _StatCardData data;

  const _StatisticChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, size: 20, color: data.color),
          const SizedBox(height: 8),
          Text(
            data.value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: data.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.borderRadiusXS,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'processing':
        return const Color(0xFF6366F1);
      default:
        return Colors.grey;
    }
  }
}
