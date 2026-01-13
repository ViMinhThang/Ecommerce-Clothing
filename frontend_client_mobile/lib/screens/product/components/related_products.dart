import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/services/product_service.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';

class RelatedProducts extends StatefulWidget {
  final int productId;

  const RelatedProducts({super.key, required this.productId});

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  final ProductService _productService = ProductService();

  bool _isLoading = true;
  String? _error;
  List<ProductView> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchSimilarProducts();
  }

  Future<void> _fetchSimilarProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _productService.getSimilarProduct(widget.productId);
      if (!mounted) return;
      setState(() {
        _products = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load related products';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Row(
        children: [
          Expanded(
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: _fetchSimilarProducts,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (_products.isEmpty) {
      return const Text('No related products available');
    }

    final similar = _products.take(4).toList();
    final recommended = _products.length > 4
        ? _products.skip(4).take(4).toList()
        : <ProductView>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Similar products',
          products: similar,
          cardBuilder: _buildProductCard,
        ),
        if (recommended.isNotEmpty) ...[
          const SizedBox(height: 24),
          _Section(
            title: "We think you'll love",
            products: recommended,
            cardBuilder: _buildProductCard,
          ),
        ],
      ],
    );
  }

  Widget _buildProductCard(ProductView product) {
    final resolvedImage = _resolveImageUrl(product.imageUrl);
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: resolvedImage.isNotEmpty
                  ? Image.network(
                      resolvedImage,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (product.isOnSale) ...[
                      Text(
                        '${product.basePrice.toStringAsFixed(2)}\$',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '${product.displayPrice.toStringAsFixed(2)}\$',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: product.isOnSale ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            product.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _resolveImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http')) return FileUtils.fixImgUrl(url);
    return FileUtils.fixImgUrl('${ApiConfig.baseUrl}$url');
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<ProductView> products;
  final Widget Function(ProductView) cardBuilder;

  const _Section({
    required this.title,
    required this.products,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return cardBuilder(products[index]);
            },
          ),
        ),
      ],
    );
  }
}
