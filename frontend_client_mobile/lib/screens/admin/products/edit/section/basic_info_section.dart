import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../../config/theme_config.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);

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
              Icon(Icons.edit_outlined, size: 20, color: AppTheme.primaryBlack),
              const SizedBox(width: AppTheme.spaceXS),
              Text(
                'Basic Information',
                style: AppTheme.h4.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          TextFormField(
            controller: viewModel.nameController,
            decoration: _inputDecoration('Product Name'),
            style: AppTheme.bodyMedium,
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Please enter a name' : null,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          TextFormField(
            controller: viewModel.descriptionController,
            decoration: _inputDecoration('Description'),
            style: AppTheme.bodyMedium,
            maxLines: 4,
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
