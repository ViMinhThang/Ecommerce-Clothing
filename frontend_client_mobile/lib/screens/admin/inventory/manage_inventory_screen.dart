import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/layouts/admin_layout.dart';
import 'package:frontend_client_mobile/providers/inventory_provider.dart';
import 'package:frontend_client_mobile/models/stock_check_response.dart';
import 'package:frontend_client_mobile/widgets/stock_status_badge.dart';
import 'package:provider/provider.dart';

class ManageInventoryScreen extends StatefulWidget {
  const ManageInventoryScreen({super.key});

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _inventoryList = [];
  String _filter = 'all'; // all, low_stock, out_of_stock

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<InventoryProvider>();
      
      // For now, we'll check stock for first 20 variant IDs
      List<Map<String, dynamic>> items = [];
      for (int i = 1; i <= 20; i++) {
        try {
          final stock = await provider.checkStock(i);
          if (stock != null) {
            items.add({
              'stock': stock,
            });
          }
        } catch (e) {
          debugPrint('Error checking stock for variant $i: $e');
        }
      }
      
      setState(() {
        _inventoryList = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading inventory: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredList {
    switch (_filter) {
      case 'low_stock':
        return _inventoryList.where((item) {
          final stock = item['stock'] as StockCheckResponse;
          return stock.isLowStock == true;
        }).toList();
      case 'out_of_stock':
        return _inventoryList.where((item) {
          final stock = item['stock'] as StockCheckResponse;
          return stock.inStock == false;
        }).toList();
      default:
        return _inventoryList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentPage: 'inventory',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inventory Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadInventory,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Statistics Cards
            Row(
              children: [
                _buildStatCard(
                  'Total Items',
                  _inventoryList.length.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Low Stock',
                  _inventoryList.where((i) {
                    final stock = i['stock'] as StockCheckResponse;
                    return stock.isLowStock == true;
                  }).length.toString(),
                  Icons.warning,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Out of Stock',
                  _inventoryList.where((i) {
                    final stock = i['stock'] as StockCheckResponse;
                    return stock.inStock == false;
                  }).length.toString(),
                  Icons.remove_circle,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Chips
            Row(
              children: [
                const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == 'all',
                  onSelected: (selected) {
                    if (selected) setState(() => _filter = 'all');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Low Stock'),
                  selected: _filter == 'low_stock',
                  onSelected: (selected) {
                    if (selected) setState(() => _filter = 'low_stock');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Out of Stock'),
                  selected: _filter == 'out_of_stock',
                  onSelected: (selected) {
                    if (selected) setState(() => _filter = 'out_of_stock');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Inventory List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No inventory items found',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : Card(
                          elevation: 2,
                          child: ListView.separated(
                            itemCount: _filteredList.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _filteredList[index];
                              final stock = item['stock'] as StockCheckResponse;
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text('${stock.variantId}'),
                                ),
                                title: Text(
                                  'Product Variant #${stock.variantId}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text('Stock: ${stock.availableStock} units'),
                                trailing: StockStatusBadge(stockInfo: stock),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
