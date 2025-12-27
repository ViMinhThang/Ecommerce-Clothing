import 'package:flutter/material.dart';
import 'basic_info_section.dart';
import 'category_section.dart';
import 'image_section.dart';
import 'variants_section.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(background: ImageSection()),
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('BASIC INFORMATION', Icons.info_outline),
                const SizedBox(height: 16),
                BasicInfoSection(),

                const SizedBox(height: 32),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 32),

                _buildSectionHeader('CATEGORY', Icons.category_outlined),
                const SizedBox(height: 16),
                CategorySection(),

                const SizedBox(height: 32),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 32),

                _buildSectionHeader('PRODUCT VARIANTS', Icons.palette_outlined),
                const SizedBox(height: 16),
                VariantsSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
