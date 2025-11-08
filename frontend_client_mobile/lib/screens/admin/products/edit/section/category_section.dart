import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../../models/category.dart';
import '../../../../../../providers/category_provider.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        if (viewModel.isLoadingCategories && provider.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return DropdownButtonFormField<Category>(
          value: viewModel.selectedCategory,
          onChanged: (value) => viewModel.selectedCategory = value,
          items: provider.categories
              .map<DropdownMenuItem<Category>>(
                (cat) => DropdownMenuItem(value: cat, child: Text(cat.name)),
              )
              .toList(),
          decoration: _inputDecoration('Category'),
          validator: (value) => value == null ? 'Required' : null,
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );
}
