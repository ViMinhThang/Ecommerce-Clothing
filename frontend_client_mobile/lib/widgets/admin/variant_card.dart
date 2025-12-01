import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as models;
import 'package:frontend_client_mobile/models/size.dart' as models;
import 'package:frontend_client_mobile/utils/color_utils.dart';
import '../../../models/product_variant.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB0B0B0), // Visible mid-gray
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              24,
              12,
              12,
            ), // Top padding for delete button
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<models.Color>(
                        value: variant.color,
                        items: colors
                            .map(
                              (color) => DropdownMenuItem<models.Color>(
                                value: color,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.getColorByName(
                                          color.colorName,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        color.colorName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => onColorChanged(index, value!),
                        decoration: _inputDecoration('Color'),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<models.Size>(
                        value: variant.size,
                        items: sizes
                            .map(
                              (size) => DropdownMenuItem<models.Size>(
                                value: size,
                                child: Text(size.sizeName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => onSizeChanged(index, value!),
                        decoration: _inputDecoration('Size'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                            double.tryParse(value ?? '') == null
                            ? 'Invalid'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: variant.price.salePrice.toString(),
                        decoration: _inputDecoration('Sale Price'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (value) => onSalePriceChanged(index, value),
                        validator: (value) =>
                            double.tryParse(value ?? '') == null
                            ? 'Invalid'
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Color(0xFFEF5350)),
              splashRadius: 16,
              tooltip: 'Remove variant',
              onPressed: () => onRemove(index),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF6B6B6B),
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFB0B0B0), // Visible mid-gray
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6B6B6B), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ), // Reduced padding
      filled: true,
      fillColor: Colors.white,
    );
  }
}
