import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';

class CatalogCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  const CatalogCard({required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    FileUtils.fixImgUrl(category.imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),

                  // Tap Interaction
                  Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: onTap),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (category.description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            category.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
