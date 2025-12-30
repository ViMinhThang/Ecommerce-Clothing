import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar products',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
                'Balloon sleeve tiered ruffle mini dress',
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
        Text(
          "We think you'll love",
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
                'One shoulder piping detail frill dress',
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
      ],
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
                  color: Colors.grey[100],
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
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (newPrice != null) ...[
                Text(
                  oldPrice,
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: Colors.grey[400],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  newPrice,
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ] else
                Text(
                  oldPrice,
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 13,
              color: Colors.black87,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
