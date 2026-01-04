import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/layouts/admin_layout.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:frontend_client_mobile/screens/admin/vouchers/voucher_form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManageVouchersScreen extends StatefulWidget {
  const ManageVouchersScreen({super.key});

  @override
  State<ManageVouchersScreen> createState() => _ManageVouchersScreenState();
}

class _ManageVouchersScreenState extends State<ManageVouchersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoucherProvider>().loadVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoucherProvider>(
      builder: (context, provider, _) {
        return AdminLayout(
          title: 'Vouchers',
          selectedIndex: 7,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToForm(context),
            backgroundColor: AppTheme.primaryBlack,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(VoucherProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${provider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadVouchers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.vouchers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No vouchers yet', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _navigateToForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Voucher'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlack),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadVouchers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: provider.vouchers.length,
        itemBuilder: (context, index) {
          return _buildVoucherCard(provider.vouchers[index], provider);
        },
      ),
    );
  }

  Widget _buildVoucherCard(Voucher voucher, VoucherProvider provider) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    voucher.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: voucher.isPercentage ? Colors.blue[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: voucher.isPercentage ? Colors.blue : Colors.green,
                    ),
                  ),
                  child: Text(
                    voucher.discountDisplay,
                    style: TextStyle(
                      color: voucher.isPercentage ? Colors.blue[700] : Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(voucher.status),
              ],
            ),
            if (voucher.description != null) ...[
              const SizedBox(height: 12),
              Text(
                voucher.description!,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.shopping_cart_outlined, 'Min: \$${voucher.minOrderAmount.toInt()}'),
                const SizedBox(width: 8),
                if (voucher.isPercentage)
                  _buildInfoChip(Icons.arrow_downward, 'Max: \$${voucher.maxDiscountAmount.toInt()}'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.people_outline, '${voucher.usedCount}/${voucher.usageLimit}'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  voucher.startDate != null && voucher.endDate != null
                      ? '${dateFormat.format(voucher.startDate!)} - ${dateFormat.format(voucher.endDate!)}'
                      : 'No date limit',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _navigateToForm(context, voucher: voucher),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: Colors.blue,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _confirmDelete(voucher, provider),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    
    switch (status) {
      case 'ACTIVE':
        bgColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        break;
      case 'INACTIVE':
        bgColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        break;
      case 'EXPIRED':
        bgColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        break;
      default:
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  void _navigateToForm(BuildContext context, {Voucher? voucher}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoucherFormScreen(voucher: voucher),
      ),
    ).then((_) {
      context.read<VoucherProvider>().loadVouchers();
    });
  }

  void _confirmDelete(Voucher voucher, VoucherProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Voucher'),
        content: Text('Are you sure you want to delete "${voucher.code}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteVoucher(voucher.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voucher deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
