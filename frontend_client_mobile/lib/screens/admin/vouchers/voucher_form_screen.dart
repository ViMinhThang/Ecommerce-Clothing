import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VoucherFormScreen extends StatefulWidget {
  final Voucher? voucher;

  const VoucherFormScreen({super.key, this.voucher});

  @override
  State<VoucherFormScreen> createState() => _VoucherFormScreenState();
}

class _VoucherFormScreenState extends State<VoucherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _usageLimitController = TextEditingController();

  String _discountType = 'PERCENTAGE';
  String _status = 'ACTIVE';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  bool get isEditing => widget.voucher != null;

  @override
  void initState() {
    super.initState();
    if (widget.voucher != null) {
      final v = widget.voucher!;
      _codeController.text = v.code;
      _descriptionController.text = v.description ?? '';
      _discountType = v.discountType;
      _discountValueController.text = v.discountValue.toString();
      _minOrderController.text = v.minOrderAmount.toString();
      _maxDiscountController.text = v.maxDiscountAmount.toString();
      _usageLimitController.text = v.usageLimit.toString();
      _status = v.status;
      _startDate = v.startDate;
      _endDate = v.endDate;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Voucher' : 'Create Voucher'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCard([
              _buildTextField(
                controller: _codeController,
                label: 'Voucher Code',
                hint: 'e.g., SUMMER25',
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'e.g., 25% off summer sale',
                maxLines: 2,
              ),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              const Text('Discount Type', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeOption('PERCENTAGE', 'Percentage (%)', Icons.percent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeOption('FIXED_AMOUNT', 'Fixed Amount (\$)', Icons.attach_money),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _discountValueController,
                      label: _discountType == 'PERCENTAGE' ? 'Discount (%)' : 'Discount (\$)',
                      hint: _discountType == 'PERCENTAGE' ? '10' : '20',
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                  ),
                  if (_discountType == 'PERCENTAGE') ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _maxDiscountController,
                        label: 'Max Discount (\$)',
                        hint: '50',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ],
              ),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              _buildTextField(
                controller: _minOrderController,
                label: 'Minimum Order Amount (\$)',
                hint: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _usageLimitController,
                label: 'Usage Limit',
                hint: '0 = unlimited',
                keyboardType: TextInputType.number,
              ),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              const Text('Valid Period', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDatePicker('Start Date', _startDate, (d) => setState(() => _startDate = d))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDatePicker('End Date', _endDate, (d) => setState(() => _endDate = d))),
                ],
              ),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusOption('ACTIVE', 'Active', Colors.green),
                  const SizedBox(width: 12),
                  _buildStatusOption('INACTIVE', 'Inactive', Colors.orange),
                ],
              ),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        isEditing ? 'Update Voucher' : 'Create Voucher',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon) {
    final selected = _discountType == value;
    return GestureDetector(
      onTap: () => setState(() => _discountType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryBlack : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppTheme.primaryBlack : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(String value, String label, Color color) {
    final selected = _status == value;
    return GestureDetector(
      onTap: () => setState(() => _status = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? color : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? color : Colors.grey[600], fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onSelect) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null ? dateFormat.format(date) : label,
                style: TextStyle(color: date != null ? Colors.black : Colors.grey[500]),
              ),
            ),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'code': _codeController.text.toUpperCase(),
      'description': _descriptionController.text,
      'discountType': _discountType,
      'discountValue': double.tryParse(_discountValueController.text) ?? 0,
      'minOrderAmount': double.tryParse(_minOrderController.text) ?? 0,
      'maxDiscountAmount': double.tryParse(_maxDiscountController.text) ?? 0,
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'usageLimit': int.tryParse(_usageLimitController.text) ?? 0,
      'status': _status,
    };

    final provider = context.read<VoucherProvider>();
    bool success;

    if (isEditing) {
      success = await provider.updateVoucher(widget.voucher!.id, data);
    } else {
      success = await provider.createVoucher(data);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Voucher updated' : 'Voucher created')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.error}'), backgroundColor: Colors.red),
      );
    }
  }
}
