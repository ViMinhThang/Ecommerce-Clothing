import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product_image.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/size_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';
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

  late final TextEditingController nameController = TextEditingController(
    text: existingProduct?.name ?? '',
  );
  late final TextEditingController descriptionController =
      TextEditingController(text: existingProduct?.description ?? '');

  Category? _selectedCategory;
  final List<XFile> _selectedImages = [];
  List<int> _existingImageIds = [];
  List<ProductVariant> _variants = [];
  bool _isInitializing = false;
  bool _isSaving = false;

  // Getters
  Category? get selectedCategory => _selectedCategory;
  List<XFile> get selectedImages => _selectedImages;
  List<int> get existingImageIds => _existingImageIds;
  List<ProductVariant> get variants => _variants;
  bool get isInitializing => _isInitializing;
  bool get isSaving => _isSaving;

  // Get existing images from product that are still selected
  List<ProductImage> get existingImages {
    if (existingProduct == null || existingProduct!.images == null) return [];
    return existingProduct!.images!
        .where((img) => _existingImageIds.contains(img.id))
        .toList();
  }

  // Mapping from providers
  List<Category> get categories => categoryProvider.categories;
  List<product_color.Color> get colors => colorProvider.colors;
  List<Size> get sizes => sizeProvider.sizes;

  set selectedCategory(Category? value) {
    if (_selectedCategory != value) {
      _selectedCategory = value;
      notifyListeners();
    }
  }

  static const double defaultPrice = 0.0;

  Future<void> initialize() async {
    selectedCategory = existingProduct?.category;
    if (existingProduct != null) {
      _variants = existingProduct!.variants.map((v) => v.copyWith()).toList();
      _existingImageIds =
          existingProduct!.images?.map((img) => img.id).toList() ?? [];
      print("exsiting image ids " + _existingImageIds.toString());
    }
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isInitializing = true;
    notifyListeners();

    try {
      await Future.wait([
        categoryProvider.initialize(),
        colorProvider.initialize(),
        sizeProvider.initialize(),
      ]);

      _syncVariantsWithProviders();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  void _syncVariantsWithProviders() {
    if (_variants.isEmpty) return;

    for (int i = 0; i < _variants.length; i++) {
      final v = _variants[i];
      final officialColor =
          colors.firstWhereOrNull((c) => c.id == v.color.id) ?? v.color;
      final officialSize =
          sizes.firstWhereOrNull((s) => s.id == v.size.id) ?? v.size;

      _variants[i] = v.copyWith(color: officialColor, size: officialSize);
    }
  }

  Future<void> pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        _selectedImages.addAll(pickedFiles);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      rethrow;
    }
  }

  void removeSelectedImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  void removeExistingImage(int imageId) {
    _existingImageIds.remove(imageId);
    notifyListeners();
  }

  void addVariant() {
    if (colors.isEmpty || sizes.isEmpty) {
      debugPrint('Cannot add variant: Colors or Sizes list is empty');
      return;
    }
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
    _variants[index] = _variants[index].copyWith(color: color);
    notifyListeners();
  }

  void updateVariantSize(int index, Size size) {
    _variants[index] = _variants[index].copyWith(size: size);
    notifyListeners();
  }

  void updateVariantBasePrice(int index, String value) {
    final v = _variants[index];
    _variants[index] = v.copyWith(
      price: v.price.copyWith(
        basePrice: double.tryParse(value) ?? defaultPrice,
      ),
    );
    notifyListeners();
  }

  void updateVariantSalePrice(int index, String value) {
    final v = _variants[index];
    _variants[index] = v.copyWith(
      price: v.price.copyWith(
        salePrice: double.tryParse(value) ?? defaultPrice,
      ),
    );
    notifyListeners();
  }

  String? validateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return 'Please fix form errors';
    if (selectedCategory == null) return 'Please select a category';
    if (_variants.isEmpty) return 'Please add at least one variant';
    return null; // null means valid
  }

  Future<void> saveProduct() async {
    _isSaving = true;
    notifyListeners();

    try {
      final productData = Product(
        id: existingProduct?.id ?? 0,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        images: existingImages,
        category: selectedCategory!,
        variants: _variants,
      );

      if (isEditing) {
        await productProvider.updateProduct(
          productData,
          images: _selectedImages,
          existingImageIds: _existingImageIds,
        );
      } else {
        await productProvider.addProduct(productData, images: _selectedImages);
      }
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  bool hasUnsavedChanges() {
    if (existingProduct == null) {
      return nameController.text.isNotEmpty ||
          descriptionController.text.isNotEmpty ||
          selectedCategory != null ||
          _selectedImages.isNotEmpty ||
          _variants.isNotEmpty;
    }

    final hasBasicInfoChanged =
        nameController.text != existingProduct!.name ||
        descriptionController.text != existingProduct!.description ||
        selectedCategory?.id != existingProduct!.category.id;

    final hasImagesChanged =
        _selectedImages.isNotEmpty ||
        _existingImageIds.length != (existingProduct!.images?.length ?? 0);

    final hasVariantsChanged = !const ListEquality().equals(
      _variants,
      existingProduct!.variants,
    );

    return hasBasicInfoChanged || hasImagesChanged || hasVariantsChanged;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
