import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_config.dart';
import '../../../models/role_view.dart';
import '../../../models/user_request.dart';
import '../../../providers/user_provider.dart';
import '../../../services/role_service.dart';
import '../../../utils/form_decorations.dart';
import '../base/base_edit_screen.dart';

class CreateUserScreen extends BaseEditScreen<void> {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState
    extends BaseEditScreenState<void, CreateUserScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _birthDayController;
  DateTime? _selectedBirthDay;

  final RoleService _roleService = RoleService();
  List<RoleView> _availableRoles = const [];
  final List<String> _selectedRoles = [];
  bool _isLoadingRoles = false;
  String? _rolesError;

  final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  @override
  String getScreenTitle() => 'Thêm người dùng';

  @override
  int getSelectedIndex() => 3;

  @override
  String getEntityName() => 'User';

  @override
  IconData getSectionIcon() => Icons.person_add_alt_rounded;

  @override
  void initializeForm() {
    _usernameController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _birthDayController = TextEditingController();
    _loadRoles();
  }

  @override
  void disposeControllers() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _birthDayController.dispose();
  }

  @override
  bool validateForm() {
    final message = _validateFields();
    if (message != null) {
      showErrorMessage(message);
      return false;
    }
    return true;
  }

  @override
  Future<void> saveEntity() async {
    final request = UserRequest(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      roles: List<String>.from(_selectedRoles),
      birthDay: _selectedBirthDay,
    );

    await context.read<UserProvider>().createUser(request);
  }

  @override
  Future<void> handleSave() async {
    if (isSaving) return;
    if (!validateForm()) return;

    setState(() => isSaving = true);
    try {
      await saveEntity();
      if (!mounted) return;
      Navigator.pop(context, {
        'username': _usernameController.text.trim(),
        'fullName': _fullNameController.text.trim(),
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'roles': List<String>.from(_selectedRoles),
        'birthDay': _selectedBirthDay?.toIso8601String(),
      });
      showSuccessMessage();
    } catch (e) {
      if (mounted) showErrorMessage(e.toString());
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: FormDecorations.standard('Username'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _fullNameController,
          decoration: FormDecorations.standard('Full name'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _passwordController,
          decoration: FormDecorations.standard('Password'),
          obscureText: true,
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: FormDecorations.standard('Confirm password'),
          obscureText: true,
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
          controller: _birthDayController,
          readOnly: true,
          decoration: FormDecorations.standard('Birthday').copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _pickBirthDay,
            ),
          ),
          onTap: _pickBirthDay,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        _buildRolePicker(),
        const SizedBox(height: AppTheme.spaceSM),
        _SelectedRolesList(roles: _selectedRoles, onRemove: _removeRole),
      ],
    );
  }

  Widget _buildRolePicker() {
    if (_isLoadingRoles) {
      return Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: AppTheme.spaceSM),
          const Text('Đang tải danh sách role...'),
        ],
      );
    }

    if (_rolesError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _rolesError!,
              style: AppTheme.bodySmall.copyWith(color: Colors.redAccent),
            ),
          ),
          TextButton(onPressed: _loadRoles, child: const Text('Thử lại')),
        ],
      );
    }

    if (_availableRoles.isEmpty) {
      return Text(
        'Không có role khả dụng',
        style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: FormDecorations.standard('Roles'),
      hint: const Text('Chọn role'),
      items: _availableRoles
          .map(
            (role) =>
                DropdownMenuItem(value: role.name, child: Text(role.name)),
          )
          .toList(),
      onChanged: _handleRoleSelected,
    );
  }

  String? _validateFields() {
    final username = _usernameController.text.trim();
    if (username.length < 6 || username.length > 100) {
      return 'Username phải từ 6-100 ký tự';
    }

    final fullName = _fullNameController.text.trim();
    if (fullName.length < 6 || fullName.length > 100) {
      return 'Full name phải từ 6-100 ký tự';
    }

    final password = _passwordController.text;
    if (password.length < 8) {
      return 'Password tối thiểu 8 ký tự';
    }
    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return 'Password phải bắt đầu bằng chữ hoa';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password phải chứa số';
    }

    final confirm = _confirmPasswordController.text;
    if (confirm.isEmpty) {
      return 'Confirm password không được rỗng';
    }
    if (password != confirm) {
      return 'Password và confirm password phải trùng nhau';
    }

    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_emailPattern.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    if (_isLoadingRoles) {
      return 'Vui lòng chờ tải danh sách role';
    }
    if (_availableRoles.isEmpty) {
      return 'Không có role khả dụng';
    }
    if (_selectedRoles.isEmpty) {
      return 'Chọn ít nhất một role';
    }

    return null;
  }

  Future<void> _pickBirthDay() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDay ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDay = picked;
        _birthDayController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _handleRoleSelected(String? roleName) {
    if (roleName == null) return;
    if (_selectedRoles.contains(roleName)) return;
    setState(() => _selectedRoles.add(roleName));
  }

  void _removeRole(String roleName) {
    setState(() => _selectedRoles.remove(roleName));
  }

  Future<void> _loadRoles() async {
    setState(() {
      _isLoadingRoles = true;
      _rolesError = null;
    });
    try {
      final roles = await _roleService.getAllRoles();
      if (!mounted) return;
      setState(() => _availableRoles = roles);
    } catch (e) {
      if (!mounted) return;
      setState(() => _rolesError = 'Không thể tải danh sách role');
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingRoles = false);
    }
  }
}

class _SelectedRolesList extends StatelessWidget {
  final List<String> roles;
  final ValueChanged<String> onRemove;

  const _SelectedRolesList({required this.roles, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Chưa chọn role nào',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles
          .map(
            (role) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Chip(
                label: Text(role),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => onRemove(role),
              ),
            ),
          )
          .toList(),
    );
  }
}
