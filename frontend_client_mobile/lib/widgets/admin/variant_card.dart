import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/models/size.dart';
import '../../../models/product_variant.dart';

class VariantCard extends StatelessWidget {
  final int index;
  final ProductVariant variant;
  final List<Color> colors;
  final List<Size> sizes;
  final void Function(int, Color) onColorChanged;
  final void Function(int, Size) onSizeChanged;
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Color>(
                    value: variant.color,
                    items: colors
                        .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color.colorName),
                            ))
                        .toList(),
                    onChanged: (value) => onColorChanged(index, value!),
                    decoration: _inputDecoration('Color'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<Size>(
                    value: variant.size,
                    items: sizes
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size.sizeName),
                            ))
                        .toList(),
                    onChanged: (value) => onSizeChanged(index, value!),
                    decoration: _inputDecoration('Size'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: variant.price.basePrice.toString(),
                    decoration: _inputDecoration('Base Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) => onBasePriceChanged(index, value),
                    validator: (value) =>
                        double.tryParse(value ?? '') == null ? 'Invalid' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: variant.price.salePrice.toString(),
                    decoration: _inputDecoration('Sale Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) => onSalePriceChanged(index, value),
                    validator: (value) =>
                        double.tryParse(value ?? '') == null ? 'Invalid' : null,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
