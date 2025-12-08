import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedColor = 'brown';
  String selectedSize = 'S';
  int quantity = 1;
  bool isFavorite = false;

  final List<String> colors = ['brown', 'white', 'yellow'];
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'More...'];

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
                    child: Image.network(
                      'https://down-vn.img.susercontent.com/file/60e8bdd1fab3ab6c50a42f959a3fa107.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 100, color: Colors.grey),
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
                        onPressed: () => Navigator.pop(context),
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
                        const Expanded(
                          child: Text(
                            'Claudette corset shirt dress in white',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
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
                        Text(
                          '79.95\$',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '65.00\$',
                          style: TextStyle(
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
                    Row(
                      children: colors.map((color) {
                        Color colorValue;
                        if (color == 'brown') {
                          colorValue = const Color(0xFF3E2723);
                        } else if (color == 'white') {
                          colorValue = Colors.white;
                        } else {
                          colorValue = const Color(0xFFFFD700);
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
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
                                color: color == 'white' ? Colors.grey[300]! : colorValue,
                                width: 2,
                              ),
                            ),
                            child: selectedColor == color
                                ? Icon(
                              Icons.check,
                              color: color == 'white' ? Colors.black : Colors.white,
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sizes.map((size) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: selectedSize == size
                                  ? Colors.black
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: selectedSize == size
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
                            onPressed: () {},
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

                    // Description
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "A shirt is a profitable investment in the wardrobe. And here's why:",
                                style: TextStyle(fontSize: 14, height: 1.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '- shirts perfectly match with any bottom',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '- shirts made of natural fabrics are suitable for any time of the year.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
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
    );
  }

  Widget _buildProductCard(String imageUrl, String oldPrice, String? newPrice, String title) {
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
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}