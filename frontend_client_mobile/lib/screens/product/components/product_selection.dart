import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

class ProductSelection extends StatelessWidget {
  const ProductSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);
    final isLoading = provider.isLoadingVariants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color Selection
        Text(
          'Color',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : provider.availableColors.isEmpty
            ? const Text(
                'No colors available',
                style: TextStyle(color: Colors.grey),
              )
            : Row(
                children: provider.availableColors.map((colorName) {
                  final isSelected = provider.selectedColorName == colorName;
                  final isAvailable =
                      provider.selectedSizeName == null ||
                      provider.isColorAvailableForSize(
                        colorName,
                        provider.selectedSizeName!,
                      );

                  final variantWithColor = provider.variants.firstWhere(
                    (v) => v.color.colorName == colorName,
                  );
                  final hexCode = variantWithColor.color.colorCode ?? '#000000';
                  final colorValue = Color(
                    int.parse(hexCode.replaceFirst('#', '0xFF')),
                  );

                  return GestureDetector(
                    onTap: () => provider.setSelectedColor(colorName),
                    child: Opacity(
                      opacity: isAvailable ? 1.0 : 0.4,
                      child: Container(
                        width: 52,
                        height: 52,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorValue,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : (colorValue.computeLuminance() > 0.85
                                    ? Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      )
                                    : null),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: colorValue.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                size: 28,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

        const SizedBox(height: 32),

        // Size Selection
        Text(
          'Size',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : provider.availableSizes.isEmpty
            ? const Text(
                'No sizes available',
                style: TextStyle(color: Colors.grey),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...provider.availableSizes.map((sizeName) {
                    final isSelected = provider.selectedSizeName == sizeName;
                    final isAvailable =
                        provider.selectedColorName == null ||
                        provider.isSizeAvailableForColor(
                          sizeName,
                          provider.selectedColorName!,
                        );

                    return GestureDetector(
                      onTap: () => provider.setSelectedSize(sizeName),
                      child: Opacity(
                        opacity: isAvailable ? 1.0 : 0.5,
                        child: Container(
                          width: 52,
                          height: 52,
                          margin: const EdgeInsets.only(right: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            sizeName,
                            style: GoogleFonts.lora(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Text(
                    'More...',
                    style: GoogleFonts.lora(
                      color: Colors.grey[600],
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {},
          child: Text(
            'Size guide',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
