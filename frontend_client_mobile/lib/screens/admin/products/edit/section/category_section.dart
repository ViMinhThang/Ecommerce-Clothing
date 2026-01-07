import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import '../../../../../../models/category.dart';
import '../../../../../../providers/category_provider.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'COLLECTION_PLACEMENT',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          Consumer<CategoryProvider>(
            builder: (context, provider, _) {
              if (viewModel.isInitializing && provider.categories.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SYNCHRONIZING_TAXONOMY...',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.black38,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return DropdownButtonFormField<Category>(
                value: viewModel.selectedCategory,
                onChanged: (value) => viewModel.selectedCategory = value,
                items: provider.categories
                    .map<DropdownMenuItem<Category>>(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              cat.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.unfold_more,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
                dropdownColor: Colors.white,
                borderRadius: AppTheme.borderRadiusSM,
                decoration: InputDecoration(
                  hintText: 'Select a category',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusSM,
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusSM,
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusSM,
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusSM,
                    borderSide: BorderSide(color: Colors.red[700]!, width: 0.5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
