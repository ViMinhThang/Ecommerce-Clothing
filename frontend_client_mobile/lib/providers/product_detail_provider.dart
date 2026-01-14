import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:frontend_client_mobile/models/product_variant.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';
import 'package:frontend_client_mobile/services/api/cart_api_service.dart';

class ProductDetailProvider with ChangeNotifier {
  final int productId;

  Product? _product;
  List<ProductVariant> _variants = [];
  bool _isLoadingProduct = true;
  bool _isLoadingVariants = true;
  String? _errorMessage;

  int? _selectedVariantId;
  String? _selectedColorName;
  String? _selectedSizeName;
  int _quantity = 1;
  int _currentImageIndex = 0;

  ProductDetailProvider({required this.productId});

  Product? get product => _product;
  List<ProductVariant> get variants => _variants;
  bool get isLoadingProduct => _isLoadingProduct;
  bool get isLoadingVariants => _isLoadingVariants;
  String? get errorMessage => _errorMessage;

  int? get selectedVariantId => _selectedVariantId;
  String? get selectedColorName => _selectedColorName;
  String? get selectedSizeName => _selectedSizeName;
  int get quantity => _quantity;
  int get currentImageIndex => _currentImageIndex;

  bool get isLoading => _isLoadingProduct || _isLoadingVariants;

  Future<void> fetchProductAndVariants() async {
    _errorMessage = null;
    notifyListeners();
    await Future.wait([_fetchProduct(), _fetchVariants()]);
  }

  Future<void> _fetchProduct() async {
    try {
      _isLoadingProduct = true;
      notifyListeners();

      debugPrint('ProductDetailProvider: Fetching product with ID: $productId');
      _product = await ApiClient.getProductApiService().getProduct(productId);
      debugPrint('ProductDetailProvider: Product loaded: ${_product?.name}');
      debugPrint(
        'ProductDetailProvider: Product variants count: ${_product?.variants.length}',
      );
      debugPrint(
        'ProductDetailProvider: Product images count: ${_product?.images.length}',
      );

      if (_product != null &&
          _product!.variants.isNotEmpty &&
          _variants.isEmpty) {
        _variants = _product!.variants;
        _selectedVariantId = _variants.first.id;
        _selectedColorName = _variants.first.color.colorName;
        _selectedSizeName = _variants.first.size.sizeName;
      }

      _isLoadingProduct = false;
    } catch (e, stack) {
      _isLoadingProduct = false;
      _errorMessage = 'Failed to load product: $e';
      debugPrint('ProductDetailProvider ERROR: $e');
      debugPrint('Stack: $stack');
    }
    notifyListeners();
  }

  Future<void> _fetchVariants() async {
    try {
      _isLoadingVariants = true;
      notifyListeners();

      final variantApiService = ProductVariantApiService(ApiClient.dio);
      final fetchedVariants = await variantApiService.getProductVariants(
        productId,
      );

      _variants = fetchedVariants;

      // Fallback to product variants if API returns empty but product has them
      if (_variants.isEmpty &&
          _product != null &&
          _product!.variants.isNotEmpty) {
        _variants = _product!.variants;
      }

      _isLoadingVariants = false;

      // Auto-select first variant
      if (_variants.isNotEmpty) {
        _selectedVariantId = _variants.first.id;
        _selectedColorName = _variants.first.color.colorName;
        _selectedSizeName = _variants.first.size.sizeName;
      }
    } catch (e) {
      _isLoadingVariants = false;
      _errorMessage = 'Failed to load variants: $e';

      // Fallback on error if product already has variants
      if (_product != null && _product!.variants.isNotEmpty) {
        _variants = _product!.variants;
        if (_variants.isNotEmpty) {
          _selectedVariantId = _variants.first.id;
          _selectedColorName = _variants.first.color.colorName;
          _selectedSizeName = _variants.first.size.sizeName;
        }
      }
    }
    notifyListeners();
  }

  void setSelectedColor(String colorName) {
    _selectedColorName = colorName;
    // Find matching variant
    final matchingVariant = _variants.firstWhere(
      (v) =>
          v.color.colorName == colorName &&
          v.size.sizeName == _selectedSizeName,
      orElse: () => _variants.firstWhere((v) => v.color.colorName == colorName),
    );
    _selectedVariantId = matchingVariant.id;
    _selectedSizeName = matchingVariant.size.sizeName;
    notifyListeners();
  }

  void setSelectedSize(String sizeName) {
    _selectedSizeName = sizeName;
    // Find matching variant
    final matchingVariant = _variants.firstWhere(
      (v) =>
          v.size.sizeName == sizeName &&
          v.color.colorName == _selectedColorName,
      orElse: () => _variants.firstWhere((v) => v.size.sizeName == sizeName),
    );
    _selectedVariantId = matchingVariant.id;
    _selectedColorName = matchingVariant.color.colorName;
    notifyListeners();
  }

  void setQuantity(int qty) {
    if (qty >= 1) {
      _quantity = qty;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setCurrentImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }

  List<String> get availableColors {
    return _variants.map((v) => v.color.colorName).toSet().toList();
  }

  List<String> get availableSizes {
    return _variants.map((v) => v.size.sizeName).toSet().toList();
  }

  bool isSizeAvailableForColor(String sizeName, String colorName) {
    return _variants.any(
      (v) => v.color.colorName == colorName && v.size.sizeName == sizeName,
    );
  }

  bool isColorAvailableForSize(String colorName, String sizeName) {
    return _variants.any(
      (v) => v.color.colorName == colorName && v.size.sizeName == sizeName,
    );
  }

  ProductVariant? get selectedVariant {
    if (_variants.isEmpty) return null;
    return _variants.firstWhere(
      (v) => v.id == _selectedVariantId,
      orElse: () => _variants.first,
    );
  }

  String get basePriceDisplay {
    final variant = selectedVariant;
    if (variant == null) return '';
    return '${variant.price.basePrice.toStringAsFixed(2)}\$';
  }

  String get salePriceDisplay {
    final variant = selectedVariant;
    if (variant == null) return '';
    return '${variant.price.salePrice.toStringAsFixed(2)}\$';
  }

  bool get hasDiscount {
    final variant = selectedVariant;
    if (variant == null) return false;
    return variant.price.basePrice > variant.price.salePrice;
  }

  List<String> get productImageUrls {
    if (_product == null || _product!.imageUrls.isEmpty) {
      return ['https://via.placeholder.com/450x450?text=No+Image'];
    }
    return _product!.imageUrls.map((url) {
      if (url.startsWith('http')) return url;
      return '${ApiConfig.baseUrl}$url';
    }).toList();
  }
}
