import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:frontend_client_mobile/screens/admin/products/edit/section/form_sections.dart';
import 'package:frontend_client_mobile/widgets/discard_dialog.dart';
import 'package:frontend_client_mobile/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/admin_layout.dart';
import '../../../../models/product.dart';
import '../../../../providers/category_provider.dart';
import '../../../../providers/product_provider.dart';

void main() {
  runApp(const EditProductScreen());
}

class EditProductScreen extends StatefulWidget {
  final Product? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final EditProductViewModel _viewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _viewModel = EditProductViewModel(
        existingProduct: widget.product,
        productProvider: Provider.of<ProductProvider>(context, listen: false),
        categoryProvider: Provider.of<CategoryProvider>(context, listen: false),
        colorProvider: Provider.of<ColorProvider>(context, listen: false),
        sizeProvider: Provider.of<SizeProvider>(context, listen: false),
      )..initialize();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_viewModel.isSaving) return false;
    if (!_viewModel.hasUnsavedChanges()) return true;
    return await showDiscardDialog(context) ?? false;
  }

  Future<void> _handleSave() async {
    try {
      if (!_viewModel.validateForm(_formKey)) return;
      await _viewModel.saveProduct();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.isEditing ? 'Product updated' : 'Product created',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: AdminLayout(
          title: widget.product != null ? 'Edit Product' : 'Create Product',
          selectedIndex: 1,
          body: Stack(
            children: [
              _buildForm(),
              LoadingOverlay(isVisible: _viewModel.isSaving),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Consumer<EditProductViewModel>(
      builder: (context, viewModel, _) =>
          Form(key: _formKey, child: const ProductForm()),
    );
  }
}
