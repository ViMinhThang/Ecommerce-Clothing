import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/widgets/status_dropdown.dart';
import 'package:frontend_client_mobile/widgets/text_field_input.dart';
import '../../../layouts/admin_layout.dart';

class EditCategoryScreen extends StatefulWidget {
  final Map<String, dynamic>? category;

  const EditCategoryScreen({super.key, this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.category?['name'] ?? '',
    );
    _descController = TextEditingController(
      text: widget.category?['description'] ?? '',
    );
    _status = widget.category?['status'] ?? 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSave() {
    final updated = {
      'id': widget.category?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'name': _nameController.text,
      'description': _descController.text,
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
      title: widget.category == null ? 'Thêm danh mục' : 'Chỉnh sửa danh mục',
      selectedIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(label: 'Category name', controller: _nameController),

            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            StatusDropdown(
              value: _status,
              onChanged: (val) => setState(() => _status = val),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'Disable', child: Text('Disable')),
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
