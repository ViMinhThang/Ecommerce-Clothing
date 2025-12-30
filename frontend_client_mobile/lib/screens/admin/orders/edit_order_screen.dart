import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';

class EditOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? order;

  const EditOrderScreen({super.key, this.order});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController _customerController;
  late TextEditingController _totalController;
  late TextEditingController _dateController;
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(
      text: widget.order?['customer'] ?? '',
    );
    _totalController = TextEditingController(
      text: widget.order?['total'].toString() ?? '',
    );
    _dateController = TextEditingController(text: widget.order?['date'] ?? '');
    _status = widget.order?['status'] ?? 'pending';
  }

  @override
  void dispose() {
    _customerController.dispose();
    _totalController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onSave() {
    final updated = {
      'id': widget.order?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'customer': _customerController.text,
      'total': double.tryParse(_totalController.text) ?? 0,
      'date': _dateController.text,
      'status': _status,
    };

    Navigator.pop(context, updated);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.order != null;

    return AdminLayout(
      title: isEditing ? 'Edit Order' : 'Add Order',
      selectedIndex: 5,
      body: SingleChildScrollView(
        child: Container(
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
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: AppTheme.primaryBlack,
                  ),
                  const SizedBox(width: AppTheme.spaceXS),
                  Text(
                    'Order Details',
                    style: AppTheme.h4.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _customerController,
                decoration: _inputDecoration('Customer Name'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _totalController,
                decoration: _inputDecoration('Total Amount (₫)'),
                keyboardType: TextInputType.number,
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _dateController,
                decoration: _inputDecoration('Order Date'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: _inputDecoration('Status'),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(
                    value: 'processing',
                    child: Text('Processing'),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                  DropdownMenuItem(
                    value: 'cancelled',
                    child: Text('Cancelled'),
                  ),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlack,
                        foregroundColor: AppTheme.primaryWhite,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusSM,
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.save_outlined : Icons.add,
                            size: 18,
                          ),
                          const SizedBox(width: AppTheme.spaceXS),
                          Text(
                            isEditing ? 'Save Changes' : 'Create Order',
                            style: AppTheme.button.copyWith(
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceSM),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlack,
                        side: const BorderSide(
                          color: AppTheme.mediumGray,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusSM,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTheme.button.copyWith(
                          color: AppTheme.primaryBlack,
                        ),
                      ),
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

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: AppTheme.bodyMedium.copyWith(
      color: AppTheme.mediumGray,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(
        color: Color(0xFFB0B0B0), // Visible mid-gray
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spaceMD,
      vertical: 14,
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
  );
}
