import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class ColorFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onCodeChanged;

  const ColorFormSection({
    super.key,
    required this.nameController,
    required this.codeController,
    required this.status,
    required this.onStatusChanged,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Color Details',
      children: [
        _buildColorPreview(),
        const SizedBox(height: 32),
        AdminInputField(
          controller: nameController,
          label: 'Color Name',
          icon: Icons.title,
          hint: 'e.g. Midnight Black, Pearl White',
        ),
        const SizedBox(height: 24),
        AdminInputField(
          controller: codeController,
          label: 'Color Hex Code',
          icon: Icons.tag,
          hint: 'e.g. #000000, #FFFFFF',
          isMonospace: true,
          onChanged: (_) => onCodeChanged(),
        ),
        const SizedBox(height: 24),
        AdminStatusToggle(currentStatus: status, onChanged: onStatusChanged),
      ],
    );
  }

  Widget _buildColorPreview() {
    Color? previewColor;
    if (codeController.text.isNotEmpty) {
      try {
        final hexString = codeController.text.replaceAll('#', '');
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
            'Color Preview',
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
}
