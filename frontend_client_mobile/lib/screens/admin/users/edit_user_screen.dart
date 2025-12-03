import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_config.dart';
import '../../../models/user_update_request.dart';
import '../../../providers/user_provider.dart';
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
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _birthDayController;
  DateTime? _selectedBirthDay;
  bool _isPrefilling = false;
  int? _userId;

  final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  @override
  String getScreenTitle() => 'Chỉnh sửa người dùng';

  @override
  int getSelectedIndex() => 3;

  @override
  String getEntityName() => 'User';

  @override
  IconData getSectionIcon() => Icons.person_outline;

  @override
  void initializeForm() {
    _fullNameController = TextEditingController(
      text: widget.entity?['fullName'] ?? widget.entity?['name'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.entity?['email'] ?? '',
    );
    _selectedBirthDay = _parseBirthDay(widget.entity?['birthDay']);
    _birthDayController = TextEditingController(
      text: _selectedBirthDay != null ? _formatDate(_selectedBirthDay!) : '',
    );

    _userId = _extractUserId(widget.entity?['id']);
    if (_userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadUpdateInfo(_userId!);
      });
    }
  }

  @override
  void disposeControllers() {
    _fullNameController.dispose();
    _emailController.dispose();
    _birthDayController.dispose();
  }

  @override
  bool validateForm() {
    final error = _validateFields();
    if (error != null) {
      showErrorMessage(error);
      return false;
    }
    return true;
  }

  @override
  Future<void> saveEntity() async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Không tìm thấy ID người dùng');
    }

    final request = UserUpdateRequest(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      birthDay: _selectedBirthDay,
    );

    await context.read<UserProvider>().updateUser(userId, request);
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
        'id': _userId,
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
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
    if (_isPrefilling) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: FormDecorations.standard('Full name'),
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
      ],
    );
  }

  String? _validateFields() {
    final fullName = _fullNameController.text.trim();
    if (fullName.length < 6 || fullName.length > 100) {
      return 'Full name phải từ 6-100 ký tự';
    }

    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_emailPattern.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  DateTime? _parseBirthDay(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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

  int? _extractUserId(dynamic id) {
    if (id is int) return id;
    if (id is num) return id.toInt();
    return null;
  }

  Future<void> _loadUpdateInfo(int userId) async {
    setState(() => _isPrefilling = true);
    try {
      final provider = context.read<UserProvider>();
      final UserUpdateRequest dto = await provider.fetchUpdateInfo(userId);
      if (!mounted) return;
      _fullNameController.text = dto.fullName;
      _emailController.text = dto.email ?? '';
      _selectedBirthDay = dto.birthDay;
      _birthDayController.text = dto.birthDay != null
          ? _formatDate(dto.birthDay!)
          : '';
    } catch (e) {
      if (mounted) {
        showErrorMessage('Không thể tải thông tin người dùng');
      }
    } finally {
      if (mounted) {
        setState(() => _isPrefilling = false);
      }
    }
  }
}
