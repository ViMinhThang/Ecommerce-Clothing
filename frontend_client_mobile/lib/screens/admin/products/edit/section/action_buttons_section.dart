import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../config/theme_config.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sharp corners
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
                      viewModel.isEditing ? 'SAVE CHANGES' : 'CREATE PRODUCT',
                      style: AppTheme.button.copyWith(
                        color: AppTheme.primaryWhite,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sharp corners
                ),
              ),
              child: Text(
                'CANCEL',
                style: AppTheme.button.copyWith(
                  color: AppTheme.primaryBlack,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
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
      // Get form key from ancestor
      final formKey = Form.of(context).widget.key as GlobalKey<FormState>;
      if (!viewModel.validateForm(formKey)) return;

      await viewModel.saveProduct();
      if (Form.of(context).mounted) {
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
      if (Form.of(context).mounted) {
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
