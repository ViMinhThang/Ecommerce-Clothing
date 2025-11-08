import 'package:flutter/material.dart';
import 'basic_info_section.dart';
import 'category_section.dart';
import 'image_section.dart';
import 'variants_section.dart';
import 'action_buttons_section.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BasicInfoSection(),
                  SizedBox(height: 16),
                  CategorySection(),
                  SizedBox(height: 16),
                  ImageSection(),
                  SizedBox(height: 16),
                  VariantsSection(),
                  SizedBox(height: 32),
                  ActionButtonsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
