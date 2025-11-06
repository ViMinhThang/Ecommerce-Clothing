import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'edit_order_screen.dart';
import 'orders_function.dart';

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
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search Order...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      onChanged: (query) {
        setState(() {
          // nếu sau này có API thì lọc ở đây
        });
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                '#${o['id']}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            title: Text(
              o['customer'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('₫${o['total']} • ${o['date']} • ${o['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit Order',
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Order',
                  onPressed: () => _onDeleteOrder(o),
                ),
              ],
            ),
          ),
        );
      },
    );
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
