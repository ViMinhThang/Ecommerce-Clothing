import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme_config.dart';
import '../../../models/order_view.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/shared/admin_search_bar.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../../../widgets/shared/empty_state_widget.dart';
import '../base/base_manage_screen.dart';
import 'edit_order_screen.dart';

class ManageOrdersScreen extends BaseManageScreen<OrderView> {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState
    extends BaseManageScreenState<OrderView, ManageOrdersScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedSort = _SortOption.defaults.first.id;
  String _selectedStatus = _StatusOption.defaults.first.id;
  late AnimationController _animationController;

  OrderProvider get _orderProvider =>
      Provider.of<OrderProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scrollController.addListener(_handleInfiniteScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController
      ..removeListener(_handleInfiniteScroll)
      ..dispose();
    super.dispose();
  }

  @override
  String getScreenTitle() => 'Order Management';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'order';

  @override
  IconData getEmptyStateIcon() => Icons.shopping_basket_outlined;

  @override
  String getSearchHint() => 'Search Order...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _orderProvider.initialize().then((_) {
        _animationController.forward(from: 0);
      });
    });
  }

  @override
  void refreshData() {
    _orderProvider.refreshAll().then((_) {
      _animationController.forward(from: 0);
    });
  }

  @override
  void onSearchChanged(String query) {
    setState(() {});
  }

  @override
  List<OrderView> getItems() {
    final orders = context.watch<OrderProvider>().orders;
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return orders;
    return orders
        .where(
          (order) =>
              order.id.toString().contains(query) ||
              order.buyerEmail.toLowerCase().contains(query) ||
              order.status.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  bool isLoading() {
    return context.watch<OrderProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    final result = await Navigator.push<OrderView?>(
      context,
      MaterialPageRoute(builder: (_) => const EditOrderScreen()),
    );
    if (result != null) {
      await _orderProvider.createOrder(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tạo đơn hàng thành công')),
        );
      }
    }
  }

  @override
  Future<void> navigateToEdit(OrderView item) async {
    final result = await Navigator.push<OrderView?>(
      context,
      MaterialPageRoute(builder: (_) => EditOrderScreen(entity: item)),
    );
    if (result != null) {
      await _orderProvider.updateOrder(result);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã cập nhật đơn hàng')));
      }
    }
  }

  @override
  Future<void> handleDelete(OrderView item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'CANCEL ORDER',
      message: 'Are you sure you want to cancel order #${item.id}?',
    );
    if (confirmed && mounted) {
      await _orderProvider.deleteOrder(item.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cancelled order #${item.id}')));
      }
    }
  }

  @override
  List<Widget> buildHeaderWidgets() {
    return [_buildStatistics()];
  }

  @override
  Widget buildSearchSection() {
    return Column(
      children: [
        AdminSearchBar(
          hintText: getSearchHint(),
          controller: searchController,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedMenu(
                index: 0,
                child: _buildStatusDropdown(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnimatedMenu(index: 1, child: _buildSortDropdown()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedMenu({required int index, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (0.1 + (index * 0.1)).clamp(0, 1.0),
        (0.5 + (index * 0.1)).clamp(0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget buildList() {
    final items = getItems();
    if (items.isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateWidget(
          icon: getEmptyStateIcon(),
          message: 'No orders matched your criteria',
        ),
      );
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (0.1 + (index * 0.05)).clamp(0, 1.0),
            (0.6 + (index * 0.05)).clamp(0, 1.0),
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
            child: _OrderTile(
              order: item,
              onEdit: () => navigateToEdit(item),
              onDelete: () => handleDelete(item),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistics() {
    final provider = context.watch<OrderProvider>();
    final stats = provider.statistics;
    final isLoading = provider.isLoadingStatistics;

    if (isLoading && stats == null) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
        title: 'DAILY',
        periodLabel: 'TODAY',
        orders: stats.totalOrderByDay,
        revenue: stats.totalPriceByDay,
        icon: Icons.flash_on_rounded,
        accent: const Color(0xFF6366F1),
      ),
      _StatCardData(
        title: 'WEEKLY',
        periodLabel: '7D',
        orders: stats.totalOrderByWeek,
        revenue: stats.totalPriceByWeek,
        icon: Icons.auto_graph_rounded,
        accent: const Color(0xFF10B981),
      ),
      _StatCardData(
        title: 'MONTHLY',
        periodLabel: '30D',
        orders: stats.totalOrderByMonth,
        revenue: stats.totalPriceByMonth,
        icon: Icons.account_balance_wallet_rounded,
        accent: const Color(0xFFF59E0B),
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
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final animation = CurvedAnimation(
                parent: _animationController,
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

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStatus,
      decoration: _dropdownDecoration('STATUS'),
      icon: const Icon(Icons.tune_rounded, size: 18, color: Colors.black45),
      items: _StatusOption.defaults
          .map(
            (status) => DropdownMenuItem(
              value: status.id,
              child: Text(
                status.label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedStatus = value);
        final selected = _StatusOption.defaults.firstWhere(
          (element) => element.id == value,
        );
        _orderProvider.updateFilters(
          status: selected.status,
          applyStatus: true,
        );
      },
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSort,
      decoration: _dropdownDecoration('SORT'),
      icon: const Icon(Icons.sort_rounded, size: 18, color: Colors.black45),
      items: _SortOption.defaults
          .map(
            (option) => DropdownMenuItem(
              value: option.id,
              child: Text(
                option.label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedSort = value);
        final selected = _SortOption.defaults.firstWhere(
          (element) => element.id == value,
        );
        _orderProvider.updateFilters(
          sortBy: selected.sortBy,
          direction: selected.direction,
        );
      },
    );
  }

  @override
  ScrollController? getScrollController() => _scrollController;

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
      borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  void _handleInfiniteScroll() {
    if (!_scrollController.hasClients) return;
    final provider = context.read<OrderProvider>();
    final trigger = _scrollController.position.extentAfter < 200;
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
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write(',');
    }
    return buffer.toString();
  }

  static String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${parsed.year}-${two(parsed.month)}-${two(parsed.day)}';
  }
}

// Helper widgets and classes

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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppTheme.borderRadiusSM,
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Minimalist ID Circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: AppTheme.borderRadiusXS,
                  ),
                  child: Center(
                    child: Text(
                      _ManageOrdersScreenState._shortId(order.id),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.buyerEmail.isEmpty
                            ? 'ANONYMOUS_BUYER'
                            : order.buyerEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_ManageOrdersScreenState._formatDate(order.createdDate)} • ORDER_ID: ${order.id}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.black38,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₫${_ManageOrdersScreenState._formatCurrency(order.totalPrice)}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black26,
                  ),
                  onSelected: (val) {
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Cancel Order',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.1),
              borderRadius: AppTheme.borderRadiusXS,
            ),
            child: Icon(data.icon, color: data.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: GoogleFonts.outfit(
                    color: Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.orders} ORDERS',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '₫${_ManageOrdersScreenState._formatCurrency(data.revenue)}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: data.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
        color: color.withOpacity(0.1),
        borderRadius: AppTheme.borderRadiusXS,
        border: Border.all(color: color.withOpacity(0.3), width: 1),
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
