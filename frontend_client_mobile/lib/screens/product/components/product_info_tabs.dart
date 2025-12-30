import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInfoTabs extends StatelessWidget {
  const ProductInfoTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Description',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: provider.isLoadingProduct
                    ? const Text('Loading description...')
                    : Text(
                        provider.product?.description ??
                            'No description available',
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
              ),
            ],
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Customer reviews',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'No reviews yet',
                  style: GoogleFonts.lora(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
