import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../widgets/admin/variant_card.dart';
import '../../../../../config/theme_config.dart';

class VariantsSection extends StatelessWidget {
  const VariantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        border: AppTheme.borderThin,
        borderRadius: AppTheme.borderRadiusMD,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: AppTheme.primaryBlack,
                  ),
                  const SizedBox(width: AppTheme.spaceXS),
                  Text('Variants', style: AppTheme.h4.copyWith(fontSize: 16)),
                  const SizedBox(width: AppTheme.spaceXS),
                  if (viewModel.variants.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${viewModel.variants.length}',
                        style: const TextStyle(
                          color: AppTheme.primaryWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: viewModel.addVariant,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlack,
                  side: const BorderSide(
                    color: AppTheme.mediumGray, // Softer border
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceSM,
                    vertical: 4,
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          if (viewModel.variants.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              decoration: BoxDecoration(
                color: AppTheme.offWhite,
                borderRadius: AppTheme.borderRadiusSM,
                border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: 32,
                      color: AppTheme.lightGray,
                    ),
                    const SizedBox(height: AppTheme.spaceXS),
                    Text(
                      'No variants added',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Please add at least one variant',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.lightGray,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (viewModel.variants.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.variants.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                  child: VariantCard(
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
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
