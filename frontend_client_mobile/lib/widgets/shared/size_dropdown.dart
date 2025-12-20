import 'package:flutter/material.dart';
import '../../models/size.dart' as models;
import '../../config/theme_config.dart';

/// A dropdown widget for selecting a size
class SizeDropdown extends StatelessWidget {
  final models.Size? value;
  final List<models.Size> items;
  final ValueChanged<models.Size?> onChanged;
  final String label;

  const SizeDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = 'Size',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<models.Size>(
      value: value,
      items: items.map(_buildDropdownItem).toList(),
      onChanged: onChanged,
      decoration: _buildInputDecoration(),
    );
  }

  DropdownMenuItem<models.Size> _buildDropdownItem(models.Size size) {
    return DropdownMenuItem<models.Size>(
      value: size,
      child: Text(size.sizeName),
    );
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
