import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import '../widgets/variants_header.dart';
import '../widgets/variants_empty_state.dart';
import '../widgets/variants_list.dart';

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
          VariantsSectionHeader(
            count: viewModel.variants.length,
            onAddPressed: viewModel.addVariant,
          ),
          const SizedBox(height: 20),
          if (viewModel.variants.isEmpty)
            VariantsEmptyState(onAddPressed: viewModel.addVariant)
          else
            VariantsList(viewModel: viewModel),
        ],
      ),
    );
  }
}
