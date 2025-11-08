import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../widgets/admin/variant_card.dart';

class VariantsSection extends StatelessWidget {
  const VariantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Variants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: viewModel.addVariant,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (viewModel.variants.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'No variants added. Please add at least one.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.variants.length,
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
        ),
      ],
    );
  }
}
