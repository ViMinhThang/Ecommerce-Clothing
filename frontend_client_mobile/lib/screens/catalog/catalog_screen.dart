import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/providers/search_provider.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_detail_screen.dart';
import 'package:frontend_client_mobile/widgets/catalog_card.dart';
import 'package:frontend_client_mobile/widgets/search/search_overlay.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _showSearchOverlay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  void _openSearchOverlay() {
    setState(() {
      _showSearchOverlay = true;
    });
  }

  void _closeSearchOverlay() {
    if (!_showSearchOverlay) return;
    context.read<SearchProvider>().clear();
    setState(() {
      _showSearchOverlay = false;
    });
  }

  void _handleCategoryResult(CategorySearchResult result) {
    _closeSearchOverlay();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatalogDetailScreen(
          categoryName: result.name,
          categoryId: result.id,
          filterParams: {'categoryId': result.id, 'categoryName': result.name},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          appBar: AppBar(
            leadingWidth: 56,
            centerTitle: true,
            title: const Text(
              'Catalog',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: _openSearchOverlay,
                icon: const Icon(Icons.search_rounded, color: Colors.black),
              ),
            ],
          ),
          body: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.categories.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('No categories found'),
                    ],
                  ),
                );
              }

              // 3. Display Grid
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  return CatalogCard(
                    category: category,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/details',
                        arguments: {
                          'categoryId': category.id,
                          'categoryName': category.name,
                        }, // Truyền ID vào đây
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        if (_showSearchOverlay)
          Positioned.fill(
            child: SearchOverlay(
              onClose: _closeSearchOverlay,
              includeProducts: false, // Catalog search should return categories
              onCategoryTap: _handleCategoryResult,
            ),
          ),
      ],
    );
  }
}
