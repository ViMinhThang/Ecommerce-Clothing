import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import '../../../../../widgets/admin/variant_card.dart';

class VariantsSection extends StatelessWidget {
  const VariantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with label and add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.04),
                        borderRadius: AppTheme.borderRadiusXS,
                      ),
                      child: const Icon(
                        Icons.style_outlined,
                        size: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'LOGISTICS_PARAMETERS',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (viewModel.variants.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: AppTheme.borderRadiusXS,
                        ),
                        child: Text(
                          '${viewModel.variants.length} UNITS',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Add Variant Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: viewModel.addVariant,
                  borderRadius: AppTheme.borderRadiusXS,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: AppTheme.borderRadiusXS,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'INIT_ADD',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Empty State or Variants List
          if (viewModel.variants.isEmpty)
            _buildEmptyState(viewModel)
          else
            _buildVariantsList(viewModel),
        ],
      ),
    );
  }

  Widget _buildEmptyState(EditProductViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppTheme.borderRadiusSM,
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'INVENTORY_DATA_NULL',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AWAITING_VARIANT_DEFINITION',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.black38,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: viewModel.addVariant,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusXS,
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Text(
              'PROCEED_WITH_MANUAL_ENTRY',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsList(EditProductViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.variants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return VariantCard(
          key: ValueKey('variant_$index'),
          index: index,
          variant: viewModel.variants[index],
          colors: viewModel.colors,
          sizes: viewModel.sizes,
          onColorChanged: viewModel.updateVariantColor,
          onSizeChanged: viewModel.updateVariantSize,
          onBasePriceChanged: viewModel.updateVariantBasePrice,
          onSalePriceChanged: viewModel.updateVariantSalePrice,
          onRemove: viewModel.removeVariant,
        );
      },
    );
  }
}
