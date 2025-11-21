import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'edit_order_screen.dart';
import 'orders_function.dart';
import '../../../config/theme_config.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    orders = [
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
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Order Management',
      selectedIndex: 5,
      actions: [
        IconButton(
          onPressed: () => setState(_loadMockData),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _onAddOrder,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(child: _buildListView()),
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
        onChanged: (query) {
          setState(() {
            // nếu sau này có API thì lọc ở đây
          });
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
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
                  '#${o['id'].toString().substring(o['id'].toString().length - 2)}',
                  style: AppTheme.h4.copyWith(
                    color: AppTheme.primaryWhite,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            title: Text(
              o['customer'],
              style: AppTheme.h4.copyWith(fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₫${o['total']} • ${o['date']}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(o['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getStatusColor(o['status']).withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      o['status'].toString().toUpperCase(),
                      style: AppTheme.bodySmall.copyWith(
                        color: _getStatusColor(o['status']),
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
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditOrderScreen(order: o),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        final index = orders.indexWhere(
                          (item) => item['id'] == updated['id'],
                        );
                        if (index != -1) orders[index] = updated;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF5350),
                  ),
                  tooltip: 'Delete Order',
                  splashRadius: 20,
                  onPressed: () => _onDeleteOrder(o),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
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

  Future<void> _onAddOrder() async {
    final newOrder = await addOrder(context, const EditOrderScreen());
    if (newOrder != null) {
      setState(() => orders.add(newOrder));
    }
  }

  Future<void> _onDeleteOrder(Map<String, dynamic> order) async {
    final deleted = await deleteOrder(context, orders, order);
    if (deleted) setState(() {});
  }
}
