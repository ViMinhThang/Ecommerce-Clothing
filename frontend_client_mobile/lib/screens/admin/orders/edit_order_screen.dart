import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../widgets/status_dropdown.dart';
import '../../../widgets/text_field_input.dart';

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
    return AdminLayout(
      title: widget.order == null ? 'Thêm đơn hàng' : 'Chỉnh sửa đơn hàng',
      selectedIndex: 5,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(
              label: 'Customer name',
              controller: _customerController,
            ),
            const SizedBox(height: 16),
            TextFieldInput(
              label: 'Total amount (₫)',
              controller: _totalController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFieldInput(label: 'Order date', controller: _dateController),
            const SizedBox(height: 16),
            StatusDropdown(
              value: _status,
              onChanged: (val) => setState(() => _status = val),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(
                  value: 'processing',
                  child: Text('Processing'),
                ),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Save changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
