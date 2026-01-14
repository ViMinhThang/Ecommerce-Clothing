import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/widgets/admin/variant_card.dart';

class VariantsList extends StatelessWidget {
  final EditProductViewModel viewModel;

  const VariantsList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.variants.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
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
