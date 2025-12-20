import 'package:flutter/material.dart';
import '../../models/color.dart' as models;
import '../../utils/color_utils.dart';
import '../../config/theme_config.dart';

/// A dropdown widget for selecting a color
class ColorDropdown extends StatelessWidget {
  final models.Color? value;
  final List<models.Color> items;
  final ValueChanged<models.Color?> onChanged;
  final String label;

  const ColorDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = 'Color',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<models.Color>(
      value: value,
      items: items.map(_buildDropdownItem).toList(),
      onChanged: onChanged,
      decoration: _buildInputDecoration(),
      isExpanded: true,
    );
  }

  DropdownMenuItem<models.Color> _buildDropdownItem(models.Color color) {
    return DropdownMenuItem<models.Color>(
      value: color,
      child: Row(
        children: [
          _buildColorCircle(color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(color.colorName, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(models.Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: ColorUtils.getColorByName(color.colorName),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
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
