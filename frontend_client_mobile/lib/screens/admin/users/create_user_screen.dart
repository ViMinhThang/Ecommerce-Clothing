import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/product/edit/widgets/image_widgets.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/models/role_view.dart';
import 'package:frontend_client_mobile/models/user_request.dart';
import 'package:frontend_client_mobile/providers/user_provider.dart';
import 'package:frontend_client_mobile/services/role_service.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';
import '../base/base_edit_screen.dart';

class CreateUserScreen extends BaseEditScreen<void> {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends BaseEditScreenState<void, CreateUserScreen>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _animationController;

  static final _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    super.initState();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  String getScreenTitle() => 'ACCOUNT_INITIALIZATION';

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
      final msg = e is DioException && e.error is AppHttpException
          ? e.error.toString()
          : 'Có lỗi xảy ra';
      if (mounted) showErrorMessage(msg);
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget? buildHeaderImage() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: TechnicalPatternPainter()),
            ),
          ),
          Positioned(
            left: 24,
            top: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM_ACCESS_LOG',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'REGISTER_NEW_ENTITY',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: AppTheme.borderRadiusXS,
              ),
              child: const Icon(
                Icons.person_add_alt_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 80,
            child: Container(height: 1, color: Colors.white10),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const AdminSectionHeader(title: 'Account Information'),
        _buildAnimatedField(
          index: 0,
          child: AdminInputField(
            controller: _usernameController,
            label: 'UNIQUE_SYSTEM_ID (USERNAME)',
            icon: Icons.alternate_email_rounded,
            hint: 'E.G. ADMIN_01',
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 1,
          child: Row(
            children: [
              Expanded(
                child: AdminPasswordField(
                  controller: _passwordController,
                  label: 'ACCESS_PHRASE',
                  hint: '********',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminPasswordField(
                  controller: _confirmPasswordController,
                  label: 'RE_VERIFY',
                  hint: '********',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        const AdminSectionHeader(title: 'Personal Details'),
        _buildAnimatedField(
          index: 2,
          child: AdminInputField(
            controller: _fullNameController,
            label: 'FULL LEGAL NAME',
            icon: Icons.badge_outlined,
            hint: 'JOHN DOE',
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 3,
          child: AdminInputField(
            controller: _emailController,
            label: 'DIGITAL_ADDRESS',
            icon: Icons.email_outlined,
            hint: 'USER@DOMAIN.COM',
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 4,
          child: AdminInputField(
            controller: _birthDayController,
            label: 'TEMPORAL_ORIGIN',
            icon: Icons.cake_outlined,
            hint: 'YYYY-MM-DD',
            readOnly: true,
            onTap: _pickBirthDay,
          ),
        ),
        const SizedBox(height: 48),
        const AdminSectionHeader(title: 'Role & Permissions'),
        _buildAnimatedField(
          index: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RolePicker(
                isLoading: _isLoadingRoles,
                error: _rolesError,
                roles: _availableRoles,
                onRoleSelected: _handleRoleSelected,
                onRetry: _loadRoles,
              ),
              const SizedBox(height: 16),
              SelectedRolesList(roles: _selectedRoles, onRemove: _removeRole),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAnimatedField({required int index, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (0.1 + (index * 0.08)).clamp(0, 1.0),
        (0.5 + (index * 0.08)).clamp(0, 1.0),
        curve: Curves.easeOutQuart,
      ),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  String? _validateFields() {
    final username = _usernameController.text.trim();
    if (username.length < 6 || username.length > 100) {
      return 'Username must be between 6-100 characters';
    }

    final fullName = _fullNameController.text.trim();
    if (fullName.length < 6 || fullName.length > 100) {
      return 'Name must be between 6-100 characters';
    }

    final password = _passwordController.text;
    if (password.length < 8) return 'Password tối thiểu 8 ký tự';
    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return 'Password must start with an uppercase letter';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }

    final confirm = _confirmPasswordController.text;
    if (confirm.isEmpty) return 'Confirm password không được rỗng';
    if (password != confirm) return 'Passwords do not match';

    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_emailPattern.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    if (_isLoadingRoles) return 'Vui lòng chờ tải danh sách role';
    if (_availableRoles.isEmpty) return 'Không có role khả dụng';
    if (_selectedRoles.isEmpty) return 'Please select at least one role';

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
        _birthDayController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _handleRoleSelected(String? roleName) {
    if (roleName == null || _selectedRoles.contains(roleName)) return;
    setState(() => _selectedRoles.add(roleName));
  }

  void _removeRole(String roleName) =>
      setState(() => _selectedRoles.remove(roleName));

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
      setState(() => _rolesError = 'AUTHENTICATION_FAILURE_ROLE_FETCH');
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingRoles = false);
    }
  }
}
