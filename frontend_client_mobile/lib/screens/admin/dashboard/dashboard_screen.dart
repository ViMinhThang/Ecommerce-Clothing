import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_config.dart';
import '../../../layouts/admin_layout.dart';
import '../../../models/dashboard_view.dart';
import '../../../providers/dashboard_provider.dart';
import 'widgets/revenue_chart.dart';
import 'widgets/stats_grid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const List<int> _monthlyRevenue = [8, 10, 7, 12, 9, 11];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return AdminLayout(
          title: 'Admin Dashboard',
          selectedIndex: 0,
          actions: [_buildRefreshAction(provider)],
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overview', style: AppTheme.h4.copyWith(fontSize: 20)),
                const SizedBox(height: AppTheme.spaceMD),
                _buildStatsSection(provider),
                const SizedBox(height: 24),
                Text(
                  'Monthly Revenue',
                  style: AppTheme.h4.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppTheme.spaceMD),
                const RevenueChart(data: _monthlyRevenue),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefreshAction(DashboardProvider provider) {
    return IconButton(
      tooltip: 'Làm mới',
      onPressed: provider.isLoading ? null : provider.refresh,
      icon: provider.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh),
    );
  }

  Widget _buildStatsSection(DashboardProvider provider) {
    if (provider.isLoading && provider.summary == null) {
      return _buildLoadingPlaceholder();
    }

    if (provider.error != null && provider.summary == null) {
      return _buildErrorState(provider);
    }

    final stats = _mapStats(provider.summary);
    return StatsGrid(stats: stats);
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(DashboardProvider provider) {
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
            'Không thể tải dữ liệu',
            style: AppTheme.h4.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng thử lại sau vài giây.',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: provider.refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  List<DashboardStat> _mapStats(DashboardView? data) {
    const placeholder = '--';
    return [
      DashboardStat(
        title: 'Total revenue',
        value: data == null
            ? placeholder
            : '₫${_formatNumber(data.totalRevenue)}',
        icon: Icons.monetization_on_outlined,
      ),
      DashboardStat(
        title: 'Orders',
        value: data == null ? placeholder : _formatNumber(data.totalOrder),
        icon: Icons.shopping_cart_outlined,
      ),
      DashboardStat(
        title: 'Product',
        value: data == null ? placeholder : _formatNumber(data.totalProduct),
        icon: Icons.inventory_2_outlined,
      ),
      DashboardStat(
        title: 'Users',
        value: data == null ? placeholder : _formatNumber(data.totalUser),
        icon: Icons.people_outline,
      ),
    ];
  }

  static String _formatNumber(num value) {
    final digits = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return buffer.toString();
  }
}
