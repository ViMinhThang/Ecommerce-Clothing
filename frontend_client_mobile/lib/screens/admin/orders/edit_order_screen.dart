import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../models/order_view.dart';
import '../../../utils/form_decorations.dart';
import '../base/base_edit_screen.dart';

class EditOrderScreen extends BaseEditScreen<OrderView> {
  const EditOrderScreen({super.key, OrderView? entity}) : super(entity: entity);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState
    extends BaseEditScreenState<OrderView, EditOrderScreen> {
  late final TextEditingController _customerController;
  late final TextEditingController _totalController;
  late final TextEditingController _dateController;
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
      text: widget.entity?.buyerEmail ?? '',
    );
    _totalController = TextEditingController(
      text: widget.entity?.totalPrice.toString() ?? '',
    );
    _dateController = TextEditingController(
      text: widget.entity?.createdDate ?? '',
    );
    _status = widget.entity?.status ?? 'pending';
  }

  @override
  void disposeControllers() {
    _customerController.dispose();
    _totalController.dispose();
    _dateController.dispose();
  }

  @override
  bool validateForm() {
    return _customerController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final order = OrderView(
      id: widget.entity?.id ?? DateTime.now().millisecondsSinceEpoch,
      buyerEmail: _customerController.text.trim(),
      totalPrice: double.tryParse(_totalController.text) ?? 0,
      createdDate: _dateController.text.trim(),
      status: _status,
    );

    Navigator.pop(context, order);
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _customerController,
          decoration: FormDecorations.standard('Customer Email'),
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
