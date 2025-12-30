import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:provider/provider.dart';

import 'components/product_images.dart';
import 'components/product_header.dart';
import 'components/product_selection.dart';
import 'components/product_actions.dart';
import 'components/product_info_tabs.dart';
import 'components/related_products.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProductDetailProvider(productId: productId)
            ..fetchProductAndVariants(),
      child: const _ProductDetailContent(),
    );
  }
}

<<<<<<< HEAD
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int? selectedVariantId;
  String? selectedColorName;
  String? selectedSizeName;
  int quantity = 1;
  int _currentImageIndex = 0;
  int _selectedNavIndex = 1; // Track selected nav tab (1 = Product/Catalog)
  final PageController _pageController = PageController();

  // Product data from API
  Product? product;
  bool isLoadingProduct = true;

  List<ProductVariant> variants = [];
  bool isLoadingVariants = true;
  String? errorMessage;

  late ProductVariantApiService _variantApiService;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _variantApiService = ProductVariantApiService(ApiClient.dio);
    _fetchProductAndVariants();
  }

  Future<void> _fetchProductAndVariants() async {
    await Future.wait([_fetchProduct(), _fetchVariants()]);
  }

  Future<void> _fetchProduct() async {
    try {
      setState(() {
        isLoadingProduct = true;
      });

      final fetchedProduct = await ApiClient.getProductApiService().getProduct(
        widget.productId,
      );

      setState(() {
        product = fetchedProduct;
        isLoadingProduct = false;
      });
    } catch (e) {
      setState(() {
        isLoadingProduct = false;
        errorMessage = 'Failed to load product: $e';
      });
    }
  }

  Future<void> _fetchVariants() async {
    try {
      setState(() {
        isLoadingVariants = true;
        errorMessage = null;
      });

      final fetchedVariants = await _variantApiService.getProductVariants(
        widget.productId,
      );

      setState(() {
        variants = fetchedVariants;
        isLoadingVariants = false;

        // Auto-select first variant
        if (variants.isNotEmpty) {
          selectedVariantId = variants.first.id;
          selectedColorName = variants.first.color.colorName;
          selectedSizeName = variants.first.size.sizeName;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingVariants = false;
        errorMessage = 'Failed to load variants: $e';
      });
    }
  }

  List<String> get availableColors {
    return variants
        .where((v) => true) // color is non-nullable
        .map((v) => v.color.colorName)
        .toSet()
        .toList();
  }

  List<String> get availableSizes {
    return variants
        .where((v) => true) // size is non-nullable
        .map((v) => v.size.sizeName)
        .toSet()
        .toList();
  }

  ProductVariant? get selectedVariant {
    if (variants.isEmpty) return null;
    try {
      return variants.firstWhere(
        (v) => v.id == selectedVariantId,
        orElse: () => variants.first,
      );
    } catch (e) {
      return null;
    }
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
    if (product == null || product!.imageUrls.isEmpty) {
      return ['https://via.placeholder.com/450x450?text=No+Image'];
    }
    return product!.imageUrls.map((url) {
      if (url.startsWith('http')) {
        return url;
      }
      return '${ApiConfig.baseUrl}$url';
    }).toList();
  }

  String get productImageUrl {
    final urls = productImageUrls;
    return urls.isNotEmpty
        ? urls.first
        : 'https://via.placeholder.com/450x450?text=No+Image';
  }
=======
class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent();
>>>>>>> 5264eb0d1966ab2b0d30f4839e6388fb55e5db84

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImages(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductHeader(),
                    SizedBox(height: 24),
                    ProductSelection(),
                    SizedBox(height: 24),
                    ProductActions(),
                    SizedBox(height: 24),
                    ProductInfoTabs(),
                    SizedBox(height: 24),
                    RelatedProducts(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
<<<<<<< HEAD
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItemCount = cartProvider.cart?.items.length ?? 0;
          
          return BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: cartItemCount > 0,
                  label: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedNavIndex,
            onTap: (index) {
              setState(() {
                _selectedNavIndex = index;
              });
              
              // If tapping Catalog (index 1), just go back
              if (index == 1) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialTab: 1),
                    ),
                  );
                }
              } else {
                // Navigate to MainScreen with the selected tab
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(initialTab: index),
                  ),
                );
              }
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    String imageUrl,
    String oldPrice,
    String? newPrice,
    String title,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.favorite_border, size: 18),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (newPrice != null) ...[
                Text(
                  oldPrice,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  newPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ] else
                Text(
                  oldPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
=======
      bottomNavigationBar: const _ProductDetailBottomNav(),
    );
  }
}

class _ProductDetailBottomNav extends StatelessWidget {
  const _ProductDetailBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      currentIndex: 1,
      onTap: (index) {
        if (index == 1) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(initialTab: 1),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(initialTab: index),
            ),
          );
        }
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
>>>>>>> 5264eb0d1966ab2b0d30f4839e6388fb55e5db84
    );
  }
}
