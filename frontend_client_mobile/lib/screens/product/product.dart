import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:frontend_client_mobile/models/product_variant.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';
import 'package:frontend_client_mobile/services/api/cart_api_service.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int? selectedVariantId;
  String? selectedColorName;
  String? selectedSizeName;
  int quantity = 1;

  // Product data from API
  Product? product;
  bool isLoadingProduct = true;

  List<ProductVariant> variants = [];
  bool isLoadingVariants = true;
  String? errorMessage;

  late ProductVariantApiService _variantApiService;

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
          selectedColorName = variants.first.color?.colorName;
          selectedSizeName = variants.first.size?.sizeName;
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
        .where((v) => v.color != null)
        .map((v) => v.color!.colorName)
        .toSet()
        .toList();
  }

  List<String> get availableSizes {
    return variants
        .where((v) => v.size != null)
        .map((v) => v.size!.sizeName)
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

  String get productImageUrl {
    if (product?.imageUrl != null && product!.imageUrl!.isNotEmpty) {
      if (product!.imageUrl!.startsWith('http')) {
        return product!.imageUrl!;
      } else {
        return '${ApiConfig.baseUrl}${product!.imageUrl}';
      }
    }
    return 'https://via.placeholder.com/450x450?text=No+Image';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Back and Share buttons
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 450,
                    color: const Color(0xFFF5F5F5),
                    child: isLoadingProduct
                        ? const Center(child: CircularProgressIndicator())
                        : Image.network(
                            productImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          // Try to pop first, if can't pop then navigate to Catalog
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainScreen(initialTab: 1),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title and Favorite
                    Row(
                      children: [
                        Expanded(
                          child: isLoadingProduct
                              ? const Text(
                                  'Loading...',
                                  style: TextStyle(fontSize: 18),
                                )
                              : Text(
                                  product?.name ?? 'Product Name',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        Consumer<WishListProvider>(
                          builder: (context, wishlist, child) {
                            final isFav =
                                product != null &&
                                wishlist.isFavorite(product!.id);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                if (product != null) {
                                  final item = WishListItem(
                                    productId: product!.id,
                                    productName: product!.name,
                                    imageUrl: product!.imageUrl,
                                    price: variants.isNotEmpty
                                        ? variants.first.price.salePrice
                                        : 0,
                                    product: product!,
                                  );
                                  wishlist.toggleFavorite(item);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rating and Price
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.black, size: 18),
                        const Icon(Icons.star, color: Colors.black, size: 18),
                        const Icon(Icons.star, color: Colors.black, size: 18),
                        const Icon(Icons.star, color: Colors.black, size: 18),
                        const Icon(Icons.star, color: Colors.black, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          '5.0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (hasDiscount && !isLoadingVariants) ...[
                          Text(
                            basePriceDisplay,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        isLoadingVariants
                            ? const Text('...')
                            : Text(
                                salePriceDisplay,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Color Selection
                    const Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    isLoadingVariants
                        ? const CircularProgressIndicator()
                        : Row(
                            children: availableColors.map((colorName) {
                              // Find variant with this color to get hex code
                              final variantWithColor = variants.firstWhere(
                                (v) => v.color?.colorName == colorName,
                              );
                              final hexCode =
                                  variantWithColor.color?.colorCode ??
                                  '#000000';
                              final colorValue = Color(
                                int.parse(hexCode.replaceFirst('#', '0xFF')),
                              );

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColorName = colorName;
                                    // Find matching variant
                                    final matchingVariant = variants.firstWhere(
                                      (v) =>
                                          v.color?.colorName == colorName &&
                                          v.size?.sizeName == selectedSizeName,
                                      orElse: () => variants.firstWhere(
                                        (v) => v.color?.colorName == colorName,
                                      ),
                                    );
                                    selectedVariantId = matchingVariant.id;
                                    selectedSizeName =
                                        matchingVariant.size?.sizeName;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorValue,
                                    border: Border.all(
                                      color: selectedColorName == colorName
                                          ? Colors.black
                                          : Colors.grey[300]!,
                                      width: selectedColorName == colorName
                                          ? 3
                                          : 2,
                                    ),
                                  ),
                                  child: selectedColorName == colorName
                                      ? Icon(
                                          Icons.check,
                                          color:
                                              colorValue.computeLuminance() >
                                                  0.5
                                              ? Colors.black
                                              : Colors.white,
                                          size: 24,
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 24),

                    // Size Selection
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    isLoadingVariants
                        ? const CircularProgressIndicator()
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: availableSizes.map((sizeName) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSizeName = sizeName;
                                    // Find matching variant
                                    final matchingVariant = variants.firstWhere(
                                      (v) =>
                                          v.size?.sizeName == sizeName &&
                                          v.color?.colorName ==
                                              selectedColorName,
                                      orElse: () => variants.firstWhere(
                                        (v) => v.size?.sizeName == sizeName,
                                      ),
                                    );
                                    selectedVariantId = matchingVariant.id;
                                    selectedColorName =
                                        matchingVariant.color?.colorName;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedSizeName == sizeName
                                        ? Colors.black
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sizeName,
                                    style: TextStyle(
                                      color: selectedSizeName == sizeName
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Size guide',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quantity and Add to Cart
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                isLoadingVariants || selectedVariantId == null
                                ? null
                                : () async {
                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final success = await cartProvider
                                        .addToCart(
                                          userId: 1,
                                          variantId: selectedVariantId!,
                                          quantity: quantity,
                                        );

                                    if (success && mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Added to cart successfully!',
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            cartProvider.error ??
                                                'Failed to add to cart',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Add to cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    ExpansionTile(
                      title: const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: isLoadingProduct
                              ? const Text('Loading description...')
                              : Text(
                                  product?.description ??
                                      'No description available',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                        ),
                      ],
                    ),

                    // Customer Reviews
                    ExpansionTile(
                      title: const Text(
                        'Customer reviews',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No reviews yet'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Similar Products
                    const Text(
                      'Similar products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/721c282000e6a24515c47fa7d6a48c16.webp',
                            '79.95\$',
                            '68.00\$',
                            'Balloon sleeve tiered ruffle mini...',
                          ),
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/4b32d3b709cb0bd6d042a37e22f08db2.webp',
                            '89.95\$',
                            '68.00\$',
                            'Marloe mini dress in white',
                          ),
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/28ab2d6870c43dc25df5e94ab14a0663.webp',
                            '79.95\$',
                            '65.00\$',
                            'Summer dress collection',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // We think you'll love
                    const Text(
                      "We think you'll love",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/721c282000e6a24515c47fa7d6a48c16.webp',
                            '69.95\$',
                            null,
                            'One shoulder piping detail frill...',
                          ),
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/4b32d3b709cb0bd6d042a37e22f08db2.webp',
                            '69.95\$',
                            null,
                            'Plisse flared pants in bright orange',
                          ),
                          _buildProductCard(
                            'https://down-vn.img.susercontent.com/file/28ab2d6870c43dc25df5e94ab14a0663.webp',
                            '89.95\$',
                            null,
                            'Athletic wear set',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
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
    );
  }
}
