import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../utils/form_decorations.dart';
import '../base/base_edit_screen.dart';

class EditUserScreen extends BaseEditScreen<Map<String, dynamic>> {
  const EditUserScreen({super.key, Map<String, dynamic>? entity})
    : super(entity: entity);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState
    extends BaseEditScreenState<Map<String, dynamic>, EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  String _status = 'active';

  @override
  String getScreenTitle() => isEditing ? 'Edit User' : 'Add User';

  @override
  int getSelectedIndex() => 3;

  @override
  String getEntityName() => 'User';

  @override
  IconData getSectionIcon() => Icons.person_outline;

  @override
  void initializeForm() {
    _nameController = TextEditingController(text: widget.entity?['name'] ?? '');
    _emailController = TextEditingController(
      text: widget.entity?['email'] ?? '',
    );
    _roleController = TextEditingController(text: widget.entity?['role'] ?? '');
    _status = widget.entity?['status'] ?? 'active';
  }

  @override
  void disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
  }

  @override
  bool validateForm() {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _roleController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    // For mock data, just return
    // In real implementation, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Override handleSave to return the user data
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
        'name': _nameController.text,
        'email': _emailController.text,
        'role': _roleController.text,
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
          controller: _nameController,
          decoration: FormDecorations.standard('Full Name'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _emailController,
          decoration: FormDecorations.standard('Email'),
          keyboardType: TextInputType.emailAddress,
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _roleController,
          decoration: FormDecorations.standard('Role'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: FormDecorations.standard('Status'),
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
          ],
          onChanged: (val) => setState(() => _status = val!),
        ),
      ],
    );
  }
}
