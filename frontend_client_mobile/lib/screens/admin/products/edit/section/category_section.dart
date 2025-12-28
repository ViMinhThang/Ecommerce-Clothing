import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../../models/category.dart';
import '../../../../../../providers/category_provider.dart';
import '../../../../../../config/theme_config.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

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
            children: [
              Icon(
                Icons.category_outlined,
                size: 20,
                color: AppTheme.primaryBlack,
              ),
              const SizedBox(width: AppTheme.spaceXS),
              Text('Category', style: AppTheme.h4.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Consumer<CategoryProvider>(
            builder: (context, provider, _) {
              if (viewModel.isInitializing && provider.categories.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spaceMD),
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlack,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              return DropdownButtonFormField<Category>(
                initialValue: viewModel.selectedCategory,
                onChanged: (value) => viewModel.selectedCategory = value,
                items: provider.categories
                    .map<DropdownMenuItem<Category>>(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(
                          cat.name,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                decoration: _inputDecoration('Select Category'),
                validator: (value) => value == null ? 'Required' : null,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryBlack,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.primaryBlack,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: AppTheme.bodyMedium.copyWith(
      color: AppTheme.mediumGray,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(
        color: Color(0xFFB0B0B0), // Visible mid-gray
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spaceMD,
      vertical: 14,
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
  );
}
