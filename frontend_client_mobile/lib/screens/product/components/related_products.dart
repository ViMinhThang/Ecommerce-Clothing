import 'package:flutter/material.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Similar Products Section
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _similarProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_similarProducts[index]);
            },
          ),
        ),
        
        const SizedBox(height: 24),
        
        // We think you'll love Section
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recommendedProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_recommendedProducts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(_DummyProduct product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Price Row with Favorite Button
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (product.originalPrice != null) ...[
                      Text(
                        '${product.originalPrice!.toStringAsFixed(2)}\$',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '${product.price.toStringAsFixed(2)}\$',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: product.originalPrice != null ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Toggle favorite
                },
                child: const Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          // Product Name
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Dummy data for Similar Products
  static final List<_DummyProduct> _similarProducts = [
    _DummyProduct(
      name: 'Balloon sleeve tiered ruffle mini...',
      price: 79.95,
      imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=300',
    ),
    _DummyProduct(
      name: 'Marloe mini dress in white',
      price: 68.00,
      originalPrice: 89.95,
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300',
    ),
    _DummyProduct(
      name: 'Summer floral dress',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=300',
    ),
    _DummyProduct(
      name: 'Elegant evening gown',
      price: 120.00,
      originalPrice: 150.00,
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=300',
    ),
  ];

  // Dummy data for Recommended Products
  static final List<_DummyProduct> _recommendedProducts = [
    _DummyProduct(
      name: 'One shoulder piping detail frill...',
      price: 69.95,
      imageUrl: 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=300',
    ),
    _DummyProduct(
      name: 'Plisse flared pants in bright orange',
      price: 69.95,
      imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=300',
    ),
    _DummyProduct(
      name: 'Casual summer top',
      price: 45.00,
      originalPrice: 55.00,
      imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=300',
    ),
    _DummyProduct(
      name: 'Classic white blouse',
      price: 55.00,
      imageUrl: 'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=300',
    ),
  ];
}

class _DummyProduct {
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;

  _DummyProduct({
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
  });
}
