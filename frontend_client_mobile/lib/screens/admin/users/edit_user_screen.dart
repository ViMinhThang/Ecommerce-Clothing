import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme_config.dart';
import '../../../models/user_update_request.dart';
import '../../../providers/user_provider.dart';
import '../base/base_edit_screen.dart';

class EditUserScreen extends BaseEditScreen<Map<String, dynamic>> {
  const EditUserScreen({super.key, super.entity});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState
    extends BaseEditScreenState<Map<String, dynamic>, EditUserScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _birthDayController;
  DateTime? _selectedBirthDay;
  bool _isPrefilling = false;
  int? _userId;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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
  String getScreenTitle() => isEditing ? 'IDENTITY_REVISION' : 'NEW_IDENTITY';

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
    final name = _fullNameController.text.isNotEmpty
        ? _fullNameController.text
        : (widget.entity?['name'] ?? 'USER');
    final nameHash = name.hashCode;
    final primaryColor = Colors.primaries[nameHash % Colors.primaries.length];

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
                  'IDENTITY_MANIFESTO',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing ? 'REVISING_PROFILE' : 'INITIALIZING_ACCOUNT',
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

          // Floating Avatar Circle
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.elasticOut,
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Decorative Lines at bottom
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(height: 1, color: Colors.white10),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFormFields() {
    if (_isPrefilling) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 1,
            ),
            const SizedBox(height: 24),
            Text(
              'SYNCHRONIZING_MANIFESTO...',
              style: GoogleFonts.outfit(
                fontSize: 10,
                letterSpacing: 2,
                color: Colors.black38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildSectionHeader('CORE IDENTITY BIOMETRICS'),
        _buildAnimatedField(
          index: 0,
          child: _buildTextField(
            controller: _fullNameController,
            label: 'FULL LEGAL IDENTIFICATION',
            icon: Icons.badge_outlined,
            hint: 'ENTER FULL NAME',
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 1,
          child: _buildTextField(
            controller: _emailController,
            label: 'DIGITAL ADDRESS (EMAIL)',
            icon: Icons.alternate_email_rounded,
            hint: 'USER@DOMAIN.COM',
            keyboard: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 2,
          child: _buildTextField(
            controller: _birthDayController,
            label: 'TEMPORAL ORIGIN (BIRTHDAY)',
            icon: Icons.cake_outlined,
            hint: 'YYYY-MM-DD',
            readOnly: true,
            onTap: _pickBirthDay,
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
          style: GoogleFonts.inter(
            fontSize: 15,
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
        (0.1 + (index * 0.1)).clamp(0, 1.0),
        (0.5 + (index * 0.1)).clamp(0, 1.0),
        curve: Curves.easeOutQuart,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
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
        showErrorMessage('CANNOT_SYNC_PROFILE_DATA');
      }
    } finally {
      if (mounted) {
        setState(() => _isPrefilling = false);
      }
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

    // Circles
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      60,
      paint..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      4,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
