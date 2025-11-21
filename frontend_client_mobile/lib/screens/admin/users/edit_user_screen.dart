import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';

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
    _status = widget.user?['status'] ?? 'active';
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
    final isEditing = widget.user != null;

    return AdminLayout(
      title: isEditing ? 'Edit User' : 'Add User',
      selectedIndex: 3,
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
                    Icons.person_outline,
                    size: 20,
                    color: AppTheme.primaryBlack,
                  ),
                  const SizedBox(width: AppTheme.spaceXS),
                  Text(
                    'User Details',
                    style: AppTheme.h4.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Full Name'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _roleController,
                decoration: _inputDecoration('Role'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: _inputDecoration('Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
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
                            isEditing ? 'Save Changes' : 'Create User',
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
