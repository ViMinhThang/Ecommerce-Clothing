import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../utils/form_decorations.dart';
import '../base/base_edit_screen.dart';

class EditOrderScreen extends BaseEditScreen<Map<String, dynamic>> {
  const EditOrderScreen({super.key, Map<String, dynamic>? entity})
    : super(entity: entity);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState
    extends BaseEditScreenState<Map<String, dynamic>, EditOrderScreen> {
  late TextEditingController _customerController;
  late TextEditingController _totalController;
  late TextEditingController _dateController;
  String _status = 'pending';

  @override
  String getScreenTitle() => isEditing ? 'Edit Order' : 'Add Order';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'Order';

  @override
  IconData getSectionIcon() => Icons.shopping_bag_outlined;

  @override
  void initializeForm() {
    _customerController = TextEditingController(
      text: widget.entity?['customer'] ?? '',
    );
    _totalController = TextEditingController(
      text: widget.entity?['total'].toString() ?? '',
    );
    _dateController = TextEditingController(text: widget.entity?['date'] ?? '');
    _status = widget.entity?['status'] ?? 'pending';
  }

  @override
  void disposeControllers() {
    _customerController.dispose();
    _totalController.dispose();
    _dateController.dispose();
  }

  @override
  bool validateForm() {
    return _customerController.text.trim().isNotEmpty &&
        _totalController.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    // For mock data, just return the updated order
    // In real implementation, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Override handleSave to return the order data
  @override
  Future<void> handleSave() async {
    if (isSaving) return;

    if (!validateForm()) {
      showErrorMessage('Please fill in all required fields');
      return;
    }

    setState(() => isSaving = true);

    try {
      await saveEntity();

      if (!mounted) return;

      final updated = {
        'id': widget.entity?['id'] ?? DateTime.now().millisecondsSinceEpoch,
        'customer': _customerController.text,
        'total': double.tryParse(_totalController.text) ?? 0,
        'date': _dateController.text,
        'status': _status,
      };

      Navigator.pop(context, updated);
      showSuccessMessage();
    } catch (e) {
      if (mounted) {
        showErrorMessage(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _customerController,
          decoration: FormDecorations.standard('Customer Name'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _totalController,
          decoration: FormDecorations.standard('Total Amount (₫)'),
          keyboardType: TextInputType.number,
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _dateController,
          decoration: FormDecorations.standard('Order Date'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: FormDecorations.standard('Status'),
          items: const [
            DropdownMenuItem(value: 'pending', child: Text('Pending')),
            DropdownMenuItem(value: 'processing', child: Text('Processing')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
          ],
          onChanged: (val) => setState(() => _status = val!),
        ),
      ],
    );
  }
}
