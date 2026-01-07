import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as model;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../providers/color_provider.dart';
import '../base/base_edit_screen.dart';

class EditColorScreen extends BaseEditScreen<model.Color> {
  const EditColorScreen({super.key, super.entity});

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState
    extends BaseEditScreenState<model.Color, EditColorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  String _status = 'active';

  @override
  String getScreenTitle() => isEditing ? 'Edit Color' : 'Add Color';

  @override
  int getSelectedIndex() => 6;

  @override
  String getEntityName() => 'Color';

  @override
  IconData getSectionIcon() => Icons.palette_outlined;

  @override
  void initializeForm() {
    _nameController = TextEditingController(
      text: widget.entity?.colorName ?? '',
    );
    _codeController = TextEditingController(
      text: widget.entity?.colorCode ?? '',
    );
    _status = widget.entity?.status ?? 'active';
  }

  @override
  void disposeControllers() {
    _nameController.dispose();
    _codeController.dispose();
  }

  @override
  bool validateForm() {
    return _nameController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);

    final color = model.Color(
      id: widget.entity?.id,
      colorName: _nameController.text.trim(),
      colorCode: _codeController.text.trim(),
      status: _status,
    );

    if (isEditing) {
      await colorProvider.updateColor(color);
    } else {
      await colorProvider.addColor(color);
    }
  }

  @override
  Widget buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColorPreview(),
          const SizedBox(height: 32),
          _buildInputField(
            controller: _nameController,
            label: 'Color Name',
            hint: 'e.g. Midnight Black, Pearl White',
            icon: Icons.title,
          ),
          const SizedBox(height: 24),
          _buildInputField(
            controller: _codeController,
            label: 'Color Hex Code',
            hint: 'e.g. #000000, #FFFFFF',
            icon: Icons.tag,
            isCode: true,
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 24),
          _buildStatusDropdown(),
        ],
      ),
    );
  }

  Widget _buildColorPreview() {
    Color? previewColor;
    if (_codeController.text.isNotEmpty) {
      try {
        final hexString = _codeController.text.replaceAll('#', '');
        previewColor = Color(int.parse('FF$hexString', radix: 16));
      } catch (e) {
        previewColor = null;
      }
    }

    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: previewColor ?? Colors.black.withValues(alpha: 0.05),
              borderRadius: AppTheme.borderRadiusXS,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: previewColor == null
                ? const Icon(
                    Icons.palette_outlined,
                    size: 32,
                    color: Colors.black26,
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            'CHROMATIC_ANALYSIS',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isCode = false,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: AppTheme.borderRadiusXS,
              ),
              child: Icon(icon, size: 14, color: Colors.black54),
            ),
            const SizedBox(width: 10),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          style: isCode
              ? GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                )
              : GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: AppTheme.borderRadiusXS,
              ),
              child: const Icon(
                Icons.info_outline,
                size: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'OPERATIONAL_STATUS',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _status,
          items: const [
            DropdownMenuItem(value: 'active', child: Text('ACTIVE')),
            DropdownMenuItem(value: 'inactive', child: Text('INACTIVE')),
          ],
          onChanged: (val) => setState(() => _status = val!),
          icon: const Icon(Icons.unfold_more, color: Colors.black54, size: 20),
          borderRadius: AppTheme.borderRadiusXS,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: _inputDecoration('Select Status'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black26,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
