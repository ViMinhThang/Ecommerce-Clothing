import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../widgets/status_dropdown.dart';
import '../../../widgets/text_field_input.dart';

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const EditUserScreen({super.key, this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?['name'] ?? '');
    _emailController = TextEditingController(text: widget.user?['email'] ?? '');
    _roleController = TextEditingController(text: widget.user?['role'] ?? '');
    _status = widget.user?['status'] ?? 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final updated = {
      'id': widget.user?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'name': _nameController.text,
      'email': _emailController.text,
      'role': _roleController.text,
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
      title: widget.user == null ? 'Thêm người dùng' : 'Chỉnh sửa người dùng',
      selectedIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(label: 'Full name', controller: _nameController),
            const SizedBox(height: 16),
            TextFieldInput(label: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            TextFieldInput(label: 'Role', controller: _roleController),
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
