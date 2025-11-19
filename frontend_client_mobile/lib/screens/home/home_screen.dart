import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/product_layout.dart';
import 'package:frontend_client_mobile/widgets/category_chip.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).initialize();
    });

    // Infinite Scroll Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final provider = Provider.of<ProductProvider>(context, listen: false);
        if (!provider.isMoreLoading && provider.hasMore) {
          provider.loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to updates efficiently
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scaffold(
          backgroundColor:
              Colors.white, // Clean white background like the image
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Eleven',
              style: GoogleFonts.lora(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await productProvider.fetchProducts(refresh: true);
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 1. Top Banner (Optional, kept from your code)
                SliverToBoxAdapter(
                  child: ClipRRect(
                    child: Container(
                      height: 325,
                      width: 375,
                      color: Colors.black87, // Dark background for contrast
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/home_banner.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          'Categories',
                          style: GoogleFonts.lora(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            const CategoryChip(label: 'All', isSelected: true),
                            const SizedBox(width: 12),
                            const CategoryChip(label: 'Dresses'),
                            const SizedBox(width: 12),
                            const CategoryChip(label: 'Jackets'),
                            const SizedBox(width: 12),
                            const CategoryChip(label: 'Coats'),
                            const SizedBox(width: 12),
                            const CategoryChip(label: 'Lingerie'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Product Grid
                if (productProvider.isLoading &&
                    productProvider.products.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = productProvider.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductPage(),
                              ),
                            );
                          },
                        );
                      }, childCount: productProvider.products.length),
                    ),
                  ),

                // 4. Loading indicator at bottom for infinite scroll
                if (productProvider.isMoreLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
