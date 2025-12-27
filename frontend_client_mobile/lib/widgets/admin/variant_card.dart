import 'package:flutter/material.dart';
import '../../models/color.dart' as models;
import '../../models/size.dart' as models;
import '../../models/product_variant.dart';
import '../shared/color_dropdown.dart';
import '../shared/size_dropdown.dart';
import '../shared/price_input_field.dart';
import '../shared/removable_card.dart';

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
    return RemovableCard(
      onRemove: () => onRemove(index),
      removeTooltip: 'Remove variant',
      child: Column(
        children: [
          _buildSelectionRow(),
          const SizedBox(height: 12),
          _buildPriceRow(),
        ],
      ),
    );
  }

  Widget _buildSelectionRow() {
    final selectedColor = _findSelectedColor();
    final selectedSize = _findSelectedSize();

    return Row(
      children: [
        Expanded(
          child: ColorDropdown(
            value: selectedColor,
            items: colors,
            onChanged: (value) {
              if (value != null) onColorChanged(index, value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizeDropdown(
            value: selectedSize,
            items: sizes,
            onChanged: (value) {
              if (value != null) onSizeChanged(index, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        Expanded(
          child: PriceInputField(
            initialValue: variant.price.basePrice.toString(),
            label: 'Base Price',
            onChanged: (value) => onBasePriceChanged(index, value),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PriceInputField(
            initialValue: variant.price.salePrice.toString(),
            label: 'Sale Price',
            onChanged: (value) => onSalePriceChanged(index, value),
          ),
        ),
      ],
    );
  }

  models.Color _findSelectedColor() {
    return colors.firstWhere(
      (c) => c.id == variant.color.id,
      orElse: () => colors.isNotEmpty ? colors.first : variant.color,
    );
  }

  models.Size _findSelectedSize() {
    return sizes.firstWhere(
      (s) => s.id == variant.size.id,
      orElse: () => sizes.isNotEmpty ? sizes.first : variant.size,
    );
  }
}
