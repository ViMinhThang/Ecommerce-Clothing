import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// A text field widget for entering price values
class PriceInputField extends StatelessWidget {
  final String initialValue;
  final String label;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const PriceInputField({
    super.key,
    required this.initialValue,
    required this.label,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: _buildInputDecoration(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (double.tryParse(value ?? '') == null) {
      return 'Invalid';
    }
    return null;
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: AppTheme.mediumGray,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
