import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/models/category.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

/// Category dropdown widget
class CategoryDropdown extends StatelessWidget {
  final EditProductViewModel viewModel;
  final List<Category> categories;

  const CategoryDropdown({
    super.key,
    required this.viewModel,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Category>(
      initialValue: viewModel.selectedCategory,
      onChanged: (value) => viewModel.selectedCategory = value,
      items: categories.map((cat) => _buildDropdownItem(cat)).toList(),
      validator: (value) => value == null ? 'Please select a category' : null,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.05),
          borderRadius: AppTheme.borderRadiusXS,
        ),
        child: const Icon(Icons.unfold_more, color: Colors.black54, size: 20),
      ),
      dropdownColor: Colors.white,
      borderRadius: AppTheme.borderRadiusSM,
      decoration: adminInputDecoration('Select a category'),
    );
  }

  DropdownMenuItem<Category> _buildDropdownItem(Category cat) {
    return DropdownMenuItem(
      value: cat,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            cat.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
