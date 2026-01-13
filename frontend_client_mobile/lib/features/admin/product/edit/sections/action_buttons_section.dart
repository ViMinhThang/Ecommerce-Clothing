import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class ActionButtonsSection extends StatelessWidget {
  final GlobalKey<FormState>? formKey;

  const ActionButtonsSection({super.key, this.formKey});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: viewModel.isSaving ? null : () => _handleSave(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlack,
                foregroundColor: AppTheme.primaryWhite,
                disabledBackgroundColor: AppTheme.mediumGray,
                disabledForegroundColor: AppTheme.lightGray,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusXS,
                ),
                elevation: 0,
              ),
              child: viewModel.isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryWhite,
                      ),
                    )
                  : Text(
                      viewModel.isEditing ? 'Save Changes' : 'Create Product',
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryWhite,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: viewModel.isSaving
                  ? null
                  : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlack,
                side: const BorderSide(color: AppTheme.primaryBlack, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusXS,
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryBlack,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);
    try {
      if (formKey != null) {
        final validationError = viewModel.validateForm(formKey!);
        if (validationError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spaceSM),
                  Expanded(child: Text(validationError)),
                ],
              ),
              backgroundColor: AppTheme.darkGray,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusSM,
              ),
            ),
          );
          return;
        }
      }

      await viewModel.saveProduct();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.primaryWhite,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spaceSM),
                Text(
                  viewModel.isEditing ? 'Product updated' : 'Product created',
                ),
              ],
            ),
            backgroundColor: AppTheme.primaryBlack,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadiusSM,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppTheme.primaryWhite,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spaceSM),
                Expanded(child: Text(e.toString())),
              ],
            ),
            backgroundColor: AppTheme.darkGray,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadiusSM,
            ),
          ),
        );
      }
    }
  }
}
