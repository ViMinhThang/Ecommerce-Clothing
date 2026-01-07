import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
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

  final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

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
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: _TechnicalPatternPainter()),
            ),
          ),

          // Main Title
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

          // Decorative Icon
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

          // Decorative Lines at bottom
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
        _buildSectionHeader('ACCOUNT_CREDENTIALS'),
        _buildAnimatedField(
          index: 0,
          child: _buildTextField(
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
                child: _buildTextField(
                  controller: _passwordController,
                  label: 'ACCESS_PHRASE',
                  icon: Icons.lock_outline_rounded,
                  hint: '********',
                  obscure: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'RE_VERIFY',
                  icon: Icons.lock_reset_rounded,
                  hint: '********',
                  obscure: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        _buildSectionHeader('BIOMETRIC_PROFILE'),
        _buildAnimatedField(
          index: 2,
          child: _buildTextField(
            controller: _fullNameController,
            label: 'FULL LEGAL NAME',
            icon: Icons.badge_outlined,
            hint: 'JOHN DOE',
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 3,
          child: _buildTextField(
            controller: _emailController,
            label: 'DIGITAL_ADDRESS',
            icon: Icons.email_outlined,
            hint: 'USER@DOMAIN.COM',
            keyboard: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 4,
          child: _buildTextField(
            controller: _birthDayController,
            label: 'TEMPORAL_ORIGIN',
            icon: Icons.cake_outlined,
            hint: 'YYYY-MM-DD',
            readOnly: true,
            onTap: _pickBirthDay,
          ),
        ),
        const SizedBox(height: 48),
        _buildSectionHeader('SYSTEM_PERMISSIONS'),
        _buildAnimatedField(
          index: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRolePicker(),
              const SizedBox(height: 16),
              _SelectedRolesList(roles: _selectedRoles, onRemove: _removeRole),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(height: 1, color: Colors.black.withOpacity(0.05)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboard,
    VoidCallback? onTap,
    bool readOnly = false,
    bool obscure = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          obscureText: obscure,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.black12, fontSize: 13),
            prefixIcon: Icon(icon, size: 18, color: Colors.black26),
            filled: true,
            fillColor: Colors.black.withOpacity(0.02),
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
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
      decoration: FormDecorations.standard(
        'Available Roles',
      ).copyWith(prefixIcon: const Icon(Icons.security_outlined, size: 20)),
      icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.black54),
      hint: Text(
        'Choose a role to add',
        style: GoogleFonts.inter(fontSize: 14),
      ),
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
      return 'Username must be between 6-100 characters';
    }

    final fullName = _fullNameController.text.trim();
    if (fullName.length < 6 || fullName.length > 100) {
      return 'Name must be between 6-100 characters';
    }

    final password = _passwordController.text;
    if (password.length < 8) {
      return 'Password tối thiểu 8 ký tự';
    }
    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return 'Password must start with an uppercase letter';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }

    final confirm = _confirmPasswordController.text;
    if (confirm.isEmpty) {
      return 'Confirm password không được rỗng';
    }
    if (password != confirm) {
      return 'Passwords do not match';
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
      return 'Please select at least one role';
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
      setState(() => _rolesError = 'AUTHENTICATION_FAILURE_ROLE_FETCH');
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingRoles = false);
    }
  }
}

class _TechnicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5;

    // Grid lines
    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Diagonal lines
    paint.color = Colors.white.withOpacity(0.1);
    for (var i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Technical Markings
    paint.color = Colors.white.withOpacity(0.2);
    canvas.drawRect(
      Rect.fromLTWH(size.width - 60, 20, 40, 40),
      paint..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      Offset(size.width - 60, 20),
      Offset(size.width - 20, 60),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SelectedRolesList extends StatelessWidget {
  final List<String> roles;
  final ValueChanged<String> onRemove;

  const _SelectedRolesList({required this.roles, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return Text(
        'No roles assigned yet',
        style: GoogleFonts.inter(
          color: Colors.black26,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles
          .map(
            (role) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: AppTheme.borderRadiusSM,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    role,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onRemove(role),
                    child: const Icon(
                      Icons.cancel,
                      size: 16,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
