import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: viewModel.isSaving ? null : () => _handleSave(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: viewModel.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    viewModel.isEditing ? 'Save Changes' : 'Create Product',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: viewModel.isSaving ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.black),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);
    try {
      // Get form key from ancestor
      final formKey = Form.of(context).widget.key as GlobalKey<FormState>;
      if (!viewModel.validateForm(formKey)) return;

      await viewModel.saveProduct();
      if (Form.of(context).mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.isEditing ? 'Product updated' : 'Product created',
            ),
          ),
        );
      }
    } catch (e) {
      if (Form.of(context).mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
