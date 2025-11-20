import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product.dart';
import '../../models/product_variant.dart';
import '../../models/price.dart';
import '../../models/size.dart';
import '../../models/color.dart' as product_color;
import '../../models/category.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';

class EditProductViewModel extends ChangeNotifier {
  EditProductViewModel({
    this.existingProduct,
    required this.productProvider,
    required this.categoryProvider,
    required this.colorProvider,
    required this.sizeProvider,
  });

  final Product? existingProduct;
  final ProductProvider productProvider;
  final CategoryProvider categoryProvider;
  final ColorProvider colorProvider;
  final SizeProvider sizeProvider;

  bool get isEditing => existingProduct != null;

  // Controllers
  late final TextEditingController nameController = TextEditingController(
    text: existingProduct?.name ?? '',
  );
  late final TextEditingController descriptionController =
      TextEditingController(text: existingProduct?.description ?? '');

  // State
  Category? _selectedCategory;
  XFile? _selectedImage;
  List<ProductVariant> _variants = [];
  bool _isLoadingCategories = false;
  bool _isLoadingColors = false;
  bool _isLoadingSizes = false;
  bool _isSaving = false;

  // Getters
  Category? get selectedCategory => _selectedCategory;
  XFile? get selectedImage => _selectedImage;
  List<ProductVariant> get variants => _variants;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingColors => _isLoadingColors;
  bool get isLoadingSizes => _isLoadingSizes;
  bool get isSaving => _isSaving;
  List<Category> get categories => categoryProvider.categories;
  List<product_color.Color> get colors => colorProvider.colors;
  List<Size> get sizes => sizeProvider.sizes;

  // Setters with change notification
  set selectedCategory(Category? value) {
    if (_selectedCategory != value) {
      _selectedCategory = value;
      notifyListeners();
    }
  }

  set selectedImage(XFile? value) {
    if (_selectedImage != value) {
      _selectedImage = value;
      notifyListeners();
    }
  }

  // Constants
  static const double defaultPrice = 0.0;

  Future<void> initialize() async {
    selectedCategory = existingProduct?.category;
    if (existingProduct != null) {
      _variants = existingProduct!.variants.map(_copyVariant).toList();
    }
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoadingCategories = true;
    _isLoadingColors = true;
    _isLoadingSizes = true;
    notifyListeners();

    try {
      await Future.wait([
        categoryProvider.initialize(),
        colorProvider.initialize(),
        sizeProvider.initialize(),
      ]);
    } finally {
      _isLoadingCategories = false;
      _isLoadingColors = false;
      _isLoadingSizes = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = pickedFile;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  void addVariant() {
    _variants.add(
      ProductVariant(
        id: 0,
        price: Price(id: 0, basePrice: defaultPrice, salePrice: defaultPrice),
        size: sizes.first,
        color: colors.first,
      ),
    );
    notifyListeners();
  }

  void removeVariant(int index) {
    _variants.removeAt(index);
    notifyListeners();
  }

  void updateVariantColor(int index, product_color.Color color) {
    final variant = _variants[index];
    _variants[index] = _copyVariantWith(variant, color: color);
    notifyListeners();
  }

  void updateVariantSize(int index, Size size) {
    final variant = _variants[index];
    _variants[index] = _copyVariantWith(variant, size: size);
    notifyListeners();
  }

  void updateVariantBasePrice(int index, String value) {
    final variant = _variants[index];
    _variants[index] = _copyVariantWith(
      variant,
      price: Price(
        id: variant.price.id,
        basePrice: double.tryParse(value) ?? defaultPrice,
        salePrice: variant.price.salePrice,
      ),
    );
    notifyListeners();
  }

  void updateVariantSalePrice(int index, String value) {
    final variant = _variants[index];
    _variants[index] = _copyVariantWith(
      variant,
      price: Price(
        id: variant.price.id,
        basePrice: variant.price.basePrice,
        salePrice: double.tryParse(value) ?? defaultPrice,
      ),
    );
    notifyListeners();
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return false;
    if (selectedCategory == null) throw Exception('Category is required');
    if (_variants.isEmpty) throw Exception('At least one variant is required');
    return true;
  }

  Future<void> saveProduct() async {
    _isSaving = true;
    notifyListeners();

    try {
      final productData = Product(
        id: existingProduct?.id ?? 0,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        imageUrl: existingProduct?.imageUrl ?? '',
        category: selectedCategory!,
        variants: _variants,
      );

      if (isEditing) {
        await productProvider.updateProduct(productData, image: selectedImage);
      } else {
        await productProvider.addProduct(productData, image: selectedImage);
      }
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  bool hasUnsavedChanges() {
    final originalName = existingProduct?.name ?? '';
    final originalDesc = existingProduct?.description ?? '';
    final originalCategory = existingProduct?.category;
    final originalVariants = existingProduct?.variants ?? [];

    return nameController.text != originalName ||
        descriptionController.text != originalDesc ||
        selectedCategory != originalCategory ||
        selectedImage != null ||
        !_variants.equals(originalVariants);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

// Helper functions
ProductVariant _copyVariant(ProductVariant variant) {
  return ProductVariant(
    id: variant.id,
    price: Price(
      id: variant.price.id,
      basePrice: variant.price.basePrice,
      salePrice: variant.price.salePrice,
    ),
    size: Size(
      id: variant.size.id,
      sizeName: variant.size.sizeName,
      status: variant.size.status,
    ),
    color: product_color.Color(
      id: variant.color.id,
      colorName: variant.color.colorName,
      status: variant.color.status,
    ),
  );
}

ProductVariant _copyVariantWith(
  ProductVariant variant, {
  Price? price,
  Size? size,
  product_color.Color? color,
}) {
  return ProductVariant(
    id: variant.id,
    price: price ?? variant.price,
    size: size ?? variant.size,
    color: color ?? variant.color,
  );
}

// Extension for comparing variant lists
extension ProductVariantListExt on List<ProductVariant> {
  bool equals(List<ProductVariant> other) {
    if (length != other.length) return false;
    for (int i = 0; i < length; i++) {
      final a = this[i];
      final b = other[i];
      if (a.color.colorName != b.color.colorName ||
          a.size.sizeName != b.size.sizeName ||
          a.price.basePrice != b.price.basePrice ||
          a.price.salePrice != b.price.salePrice) {
        return false;
      }
    }
    return true;
  }
}
