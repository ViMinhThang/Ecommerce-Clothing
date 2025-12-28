import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// Reusable action button row for forms (Save/Cancel)
/// Provides consistent layout and styling for form submission buttons
class FormActionButtons extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool isSaving;
  final bool isEditing;
  final String? saveLabel;
  final String? cancelLabel;

  const FormActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.isSaving = false,
    this.isEditing = false,
    this.saveLabel,
    this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isSaving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlack,
              foregroundColor: AppTheme.primaryWhite,
              disabledBackgroundColor: AppTheme.mediumGray,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusSM,
              ),
              elevation: 0,
            ),
            child: isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryWhite,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isEditing ? Icons.save_outlined : Icons.add,
                        size: 18,
                      ),
                      const SizedBox(width: AppTheme.spaceXS),
                      Text(
                        saveLabel ?? (isEditing ? 'Save Changes' : 'Create'),
                        style: AppTheme.button.copyWith(
                          color: AppTheme.primaryWhite,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: AppTheme.spaceSM),
        Expanded(
          child: OutlinedButton(
            onPressed: isSaving ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryBlack,
              side: BorderSide(
                color: isSaving ? AppTheme.lightGray : AppTheme.mediumGray,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusSM,
              ),
            ),
            child: Text(
              cancelLabel ?? 'Cancel',
              style: AppTheme.button.copyWith(
                color: isSaving ? AppTheme.lightGray : AppTheme.primaryBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
