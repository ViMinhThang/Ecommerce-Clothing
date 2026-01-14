import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:frontend_client_mobile/screens/admin/products/edit/section/form_sections.dart';
import 'package:frontend_client_mobile/widgets/common/discard_dialog.dart';
import 'package:frontend_client_mobile/widgets/common/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../../../models/product.dart';
import '../../../../providers/category_provider.dart';
import '../../../../providers/product_provider.dart';
import '../../../../features/admin/product/edit/sections/action_buttons_section.dart';
import '../../../admin/base/base_edit_screen.dart';

class EditProductScreen extends BaseEditScreen<Product> {
  const EditProductScreen({super.key, Product? product})
    : super(entity: product);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState
    extends BaseEditScreenState<Product, EditProductScreen> {
  late final EditProductViewModel _viewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _viewModelInitialized = false;

  @override
  String getScreenTitle() => isEditing ? 'Edit Product' : 'Create Product';

  @override
  int getSelectedIndex() => 1;

  @override
  String getEntityName() => 'Product';

  @override
  IconData getSectionIcon() => Icons.inventory_2_outlined;

  @override
  void initializeForm() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewModelInitialized) {
      _viewModel = EditProductViewModel(
        existingProduct: widget.entity,
        productProvider: Provider.of<ProductProvider>(context, listen: false),
        categoryProvider: Provider.of<CategoryProvider>(context, listen: false),
        colorProvider: Provider.of<ColorProvider>(context, listen: false),
        sizeProvider: Provider.of<SizeProvider>(context, listen: false),
      )..initialize();
      _viewModelInitialized = true;
    }
  }

  @override
  void disposeControllers() {
    _viewModel.dispose();
  }

  @override
  bool validateForm() {
    final error = _viewModel.validateForm(_formKey);
    if (error != null) {
      showErrorMessage(error);
      return false;
    }
    return true;
  }

  @override
  Future<void> saveEntity() async {
    await _viewModel.saveProduct();
  }

  @override
  Widget build(BuildContext context) {
    if (!_viewModelInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: PopScope(
        canPop: !_viewModel.isSaving && !_viewModel.hasUnsavedChanges(),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_viewModel.isSaving) return;
          if (!_viewModel.hasUnsavedChanges()) return;

          final navigator = Navigator.of(context);
          final shouldPop = await showDiscardDialog(context) ?? false;
          if (shouldPop && mounted) {
            navigator.pop(result);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Consumer<EditProductViewModel>(
                builder: (context, viewModel, _) =>
                    Form(key: _formKey, child: const ProductForm()),
              ),
              LoadingOverlay(isVisible: _viewModel.isSaving),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ActionButtonsSection(formKey: _formKey),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildFormBody() {
    return Stack(
      children: [
        super.buildFormBody(),
        LoadingOverlay(isVisible: _viewModel.isSaving),
      ],
    );
  }

  @override
  Widget buildFormFields() {
    return Consumer<EditProductViewModel>(
      builder: (context, viewModel, _) =>
          Form(key: _formKey, child: const ProductForm()),
    );
  }

  @override
  Widget buildActionButtons() {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSectionHeader() {
    return const SizedBox.shrink();
  }
}
