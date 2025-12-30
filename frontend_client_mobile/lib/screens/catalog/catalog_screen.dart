import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/screens/search/search_screen.dart';
import 'package:frontend_client_mobile/widgets/catalog/catalog_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/widgets/skeleton/category_item_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Catalog',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierDismissible: true,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, __, ___) => const SearchScreen.categories(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            icon: const Icon(Icons.search_rounded, color: Colors.black),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(
                6,
                (index) => const CategorySkeleton(),
              ),
            );
          }
          if (provider.categories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey),
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
    );
  }
}
