import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/category_provider.dart';
import 'package:frontend_client_mobile/screens/product/product.dart';
import 'package:frontend_client_mobile/widgets/catalog/category_chip.dart';
import 'package:frontend_client_mobile/screens/search/search_screen.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/providers/product_provider.dart';
import 'package:frontend_client_mobile/widgets/catalog/product_card.dart';
import 'package:frontend_client_mobile/widgets/skeleton/product_card_skeleton.dart';
import 'package:frontend_client_mobile/widgets/skeleton/category_item_widgets.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/utils/feedback_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  int _selectedCategoryId = 0;
  @override
  void initState() {
    super.initState();
    // Initial Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      productProvider.prepareForCategory(0);
      productProvider.fetchProductsByCategory(0, refresh: true);
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });

    // Infinite Scroll Listener
    _scrollController.addListener(() {
      bool isScrollAtBottom =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200;
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (isScrollAtBottom && !provider.isMoreLoading && provider.hasMore) {
        provider.loadMoreByCategory(_selectedCategoryId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index, int categoryId) {
    if (_selectedCategoryIndex == index) return;

    setState(() {
      _selectedCategoryIndex = index;
      _selectedCategoryId = categoryId;
    });

    final p = context.read<ProductProvider>();

    // Clear và bật loading ngay để kích hoạt skeleton
    p.prepareForCategory(categoryId); // phương thức mới, xem dưới
    p.fetchProductsByCategory(categoryId, refresh: true);

    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to updates efficiently
    final wishlistProvider = context.watch<WishlistProvider>();
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 56,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Eleven",
              style: GoogleFonts.lora(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      pageBuilder: (_, _, _) => const SearchScreen.products(),
                      transitionsBuilder: (_, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await productProvider.fetchProductsByCategory(
                _selectedCategoryId,
                refresh: true,
              );
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) {
                            if (categoryProvider.isLoading) {
                              return SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (_, _) =>
                                      const CategorySkeleton(),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: CategoryChip(
                                      label: "All",
                                      isSelected: _selectedCategoryIndex == 0,
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryId = 0;
                                          _selectedCategoryIndex = 0;
                                        });
                                        context
                                            .read<ProductProvider>()
                                            .prepareForCategory(0);
                                        context
                                            .read<ProductProvider>()
                                            .fetchProductsByCategory(
                                              0,
                                              refresh: true,
                                            );
                                      },
                                    ),
                                  ),
                                  ...categoryProvider.categories.map((
                                    category,
                                  ) {
                                    final index =
                                        categoryProvider.categories.indexOf(
                                          category,
                                        ) +
                                        1;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      child: CategoryChip(
                                        label: category.name,
                                        isSelected:
                                            _selectedCategoryIndex == index,
                                        onTap: () => _onCategorySelected(
                                          index,
                                          category.id!,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                if (productProvider.isLoading &&
                    productProvider.productViews.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      children: List.generate(
                        6,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ProductCardSkeleton(),
                        ),
                      ),
                    ),
                  ),
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
                      final product = productProvider.productViews[index];
                      return ProductViewCard(
                        product: product,
                        isFavorite: wishlistProvider.isProductInWishlistLocal(
                          product.id,
                        ),
                        onFavoriteToggle: () async {
                          final tokenStorage = TokenStorage();
                          final isLoggedIn = await tokenStorage.isLoggedIn();

                          if (!context.mounted) return;

                          if (!isLoggedIn) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  'Login Required',
                                  style: GoogleFonts.lora(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: const Text(
                                  'Please login to add items to your wishlist.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const MainScreen(initialTab: 4),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          final userId = await tokenStorage.readUserId() ?? 1;
                          final success = await wishlistProvider.toggleWishlist(
                            productId: product.id,
                            userId: userId,
                          );
                          if (!context.mounted) return;
                          if (success) {
                            FeedbackUtils.showWishlistToast(
                              context,
                              isAdded: wishlistProvider
                                  .isProductInWishlistLocal(product.id),
                              productName: product.name,
                            );
                          }
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                      );
                    }, childCount: productProvider.productViews.length),
                  ),
                ),

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
