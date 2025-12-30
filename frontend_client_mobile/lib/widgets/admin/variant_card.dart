import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as models;
import 'package:frontend_client_mobile/models/size.dart' as models;
import 'package:frontend_client_mobile/utils/color_utils.dart';
import '../../config/theme_config.dart';
import '../../models/product_variant.dart';
import '../../utils/form_decorations.dart';
import '../shared/color_dropdown_item.dart';

class VariantCard extends StatelessWidget {
  final int index;
  final ProductVariant variant;
  final List<models.Color> colors;
  final List<models.Size> sizes;
  final void Function(int, models.Color) onColorChanged;
  final void Function(int, models.Size) onSizeChanged;
  final void Function(int, String) onBasePriceChanged;
  final void Function(int, String) onSalePriceChanged;
  final void Function(int) onRemove;

  const VariantCard({
    super.key,
    required this.index,
    required this.variant,
    required this.colors,
    required this.sizes,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onBasePriceChanged,
    required this.onSalePriceChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusSM,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
            child: Column(
              children: [
                _buildDropdownRow(),
                const SizedBox(height: 12),
                _buildPriceRow(),
              ],
            ),
          ),
          _buildRemoveButton(),
        ],
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      children: [
        Expanded(child: _buildColorDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildSizeDropdown()),
      ],
    );
  }

  Widget _buildColorDropdown() {
    final hasColor = colors.contains(variant.color);
    return DropdownButtonFormField<models.Color>(
      initialValue: hasColor ? variant.color : null,
      items: colors
          .map(
            (color) => DropdownMenuItem<models.Color>(
              value: color,
              child: ColorDropdownItem(
                colorName: color.colorName,
                color: ColorUtils.getColorByName(color.colorName),
              ),
            ),
          )
          .toList(),
      onChanged: (value) => onColorChanged(index, value!),
      decoration: FormDecorations.standard('Color'),
      isExpanded: true,
    );
  }

  Widget _buildSizeDropdown() {
    final hasSize = sizes.contains(variant.size);
    return DropdownButtonFormField<models.Size>(
      initialValue: hasSize ? variant.size : null,
      items: sizes
          .map(
            (size) => DropdownMenuItem<models.Size>(
              value: size,
              child: Text(size.sizeName),
            ),
          )
          .toList(),
      onChanged: (value) => onSizeChanged(index, value!),
      decoration: FormDecorations.standard('Size'),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: variant.price.basePrice.toString(),
            decoration: FormDecorations.standard('Base Price'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => onBasePriceChanged(index, value),
            validator: (value) =>
                double.tryParse(value ?? '') == null ? 'Invalid' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            initialValue: variant.price.salePrice.toString(),
            decoration: FormDecorations.standard('Sale Price'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => onSalePriceChanged(index, value),
            validator: (value) =>
                double.tryParse(value ?? '') == null ? 'Invalid' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.close, size: 18, color: Color(0xFFEF5350)),
        splashRadius: 16,
        tooltip: 'Remove variant',
        onPressed: () => onRemove(index),
      ),
    );
  }
}
