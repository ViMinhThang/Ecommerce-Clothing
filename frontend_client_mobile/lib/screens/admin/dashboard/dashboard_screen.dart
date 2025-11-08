import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'widgets/stats_grid.dart';
import 'widgets/revenue_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Total revenue',
        'value': '₫245.000.000',
        'icon': Icons.monetization_on,
      },
      {'title': 'Orders', 'value': '1.280', 'icon': Icons.shopping_cart},
      {'title': 'Product', 'value': '320', 'icon': Icons.inventory},
      {'title': 'Users', 'value': '2.150', 'icon': Icons.people},
    ];

    final monthlyRevenue = [8, 10, 7, 12, 9, 11];

    return AdminLayout(
      title: 'Admin Dashboard',
      selectedIndex: 0,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 👉 Widget thống kê
            StatsGrid(stats: stats),

            const SizedBox(height: 24),
            const Text(
              'Monthly Revenue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 👉 Widget biểu đồ doanh thu
            RevenueChart(data: monthlyRevenue),
          ],
        ),
      ),
    );
  }
}
