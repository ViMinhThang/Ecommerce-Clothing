import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);

    return Column(
      children: [
        TextFormField(
          controller: viewModel.nameController,
          decoration: _inputDecoration('Product Name'),
          validator: (value) =>
              value?.trim().isEmpty ?? true ? 'Please enter a name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: viewModel.descriptionController,
          decoration: _inputDecoration('Description'),
          maxLines: 3,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );
}
