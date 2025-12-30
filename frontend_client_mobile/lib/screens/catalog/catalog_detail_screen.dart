import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:frontend_client_mobile/widgets/product_card.dart';
import 'package:frontend_client_mobile/screens/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/widgets/skeleton/product_card_skeleton.dart';

class CatalogDetailScreen extends StatelessWidget {
  final String categoryName;
  final int categoryId;
  final Map<String, dynamic> filterParams;
  const CatalogDetailScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.filterParams,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final filterProvider = context.watch<FilterProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fp = context.read<FilterProvider>();
      if (fp.categoryId == 0 || fp.categoryId != categoryId) {
        fp.initialize(categoryId);
      } else if (fp.productViews.isEmpty && !fp.isFiltering) {
        fp.refreshProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
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
                  pageBuilder: (_, __, ___) =>
                      SearchScreen.products(categoryId: categoryId),
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
      body: Builder(
        builder: (context) {
          if (filterProvider.isLoading && filterProvider.productViews.isEmpty) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    children: List.generate(
                      6,
                      (index) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ProductCardSkeleton(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (filterProvider.productViews.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return CustomScrollView(
            slivers: [
              // Thanh filter/sort dạng chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      _ChipButton(
                        icon: Icons.filter_list_rounded,
                        label: 'Filter',
                        onTap: () async {
                          // Đi tới filter page
                          await Navigator.of(
                            context,
                          ).pushNamed('/filter', arguments: filterParams);
                          await context
                              .read<FilterProvider>()
                              .refreshProducts();
                        },
                      ),
                      const SizedBox(width: 10),
                      const _SortChip(),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                        icon: const Icon(Icons.tune_rounded),
                        tooltip: 'More',
                      ),
                    ],
                  ),
                ),
              ),

              // Lưới 2 cột
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = filterProvider.productViews[index];
                    return ProductViewCard(product: product);
                  }, childCount: filterProvider.productViews.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: padding.bottom + 8)),
            ],
          );
        },
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ChipButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Widget riêng cho sort chip, tự nó là Stateful nên screen chính vẫn Stateless
class _SortChip extends StatefulWidget {
  const _SortChip();

  @override
  State<_SortChip> createState() => _SortChipState();
}

class _SortChipState extends State<_SortChip> {
  bool _popular = true;

  @override
  Widget build(BuildContext context) {
    return _ChipButton(
      icon: Icons.sort_rounded,
      label: _popular ? 'Popular' : 'Newest',
      onTap: () {
        setState(() {
          _popular = !_popular;
        });
        // Nếu muốn sort local, sort lại filterProvider.productViews ở đây
      },
    );
  }
}
