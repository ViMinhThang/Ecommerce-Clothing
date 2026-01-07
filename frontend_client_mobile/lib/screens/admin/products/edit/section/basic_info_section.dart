import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name Field
          _buildInputField(
            controller: viewModel.nameController,
            label: 'PUBLIC_CLASSIFICATION',
            hint: 'ENTER_NOMENCLATURE',
            icon: Icons.shopping_bag_outlined,
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Please enter a name' : null,
          ),

          const SizedBox(height: 24),

          // Description Field
          _buildInputField(
            controller: viewModel.descriptionController,
            label: 'TECHNICAL_SPECIFICATIONS',
            hint: 'FORMULATE_PRODUCT_MANIFESTO...',
            icon: Icons.notes_outlined,
            maxLines: 5,
            showCharacterCount: true,
            maxLength: 500,
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
    String? Function(String?)? validator,
    int maxLines = 1,
    bool showCharacterCount = false,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 14, color: Colors.black54),
            ),
            const SizedBox(width: 10),
            Text(
              label,
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

        // Text Field
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          maxLength: showCharacterCount ? maxLength : null,
          buildCounter: showCharacterCount
              ? (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) {
                  return Text(
                    '$currentLength / $maxLength',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: currentLength > (maxLength ?? 0) * 0.9
                          ? Colors.orange[700]
                          : Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              : null,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black26,
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(color: Colors.red[700]!, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(color: Colors.red[700]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
