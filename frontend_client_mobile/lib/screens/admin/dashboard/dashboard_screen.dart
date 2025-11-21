import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'widgets/stats_grid.dart';
import 'widgets/revenue_chart.dart';

import '../../../config/theme_config.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Total revenue',
        'value': '₫245.000.000',
        'icon': Icons.monetization_on_outlined,
      },
      {
        'title': 'Orders',
        'value': '1.280',
        'icon': Icons.shopping_cart_outlined,
      },
      {'title': 'Product', 'value': '320', 'icon': Icons.inventory_2_outlined},
      {'title': 'Users', 'value': '2.150', 'icon': Icons.people_outline},
    ];

    final monthlyRevenue = [8, 10, 7, 12, 9, 11];

    return AdminLayout(
      title: 'Admin Dashboard',
      selectedIndex: 0,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: AppTheme.h4.copyWith(fontSize: 20)),
            const SizedBox(height: AppTheme.spaceMD),

            // 👉 Widget thống kê
            StatsGrid(stats: stats),

            const SizedBox(height: 24),
            Text('Monthly Revenue', style: AppTheme.h4.copyWith(fontSize: 20)),
            const SizedBox(height: AppTheme.spaceMD),

            // 👉 Widget biểu đồ doanh thu
            RevenueChart(data: monthlyRevenue),
          ],
        ),
      ),
    );
  }
}
