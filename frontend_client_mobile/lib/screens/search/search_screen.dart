import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/models/product_search_result.dart';
import 'package:frontend_client_mobile/providers/search_provider.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_detail_screen.dart';
import 'package:frontend_client_mobile/screens/product/product.dart';

import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:provider/provider.dart';

enum SearchMode { products, categories }

class SearchScreen extends StatefulWidget {
  const SearchScreen.products({super.key, this.categoryId})
    : mode = SearchMode.products;

  const SearchScreen.categories({super.key})
    : mode = SearchMode.categories,
      categoryId = null;

  final SearchMode mode;
  final int? categoryId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final SearchProvider _searchProvider;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchProvider = SearchProvider();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _searchProvider.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _searchProvider.search(
        value,
        categoryId: widget.categoryId,
        includeProducts: widget.mode == SearchMode.products,
        includeCategories: widget.mode == SearchMode.categories,
      );
    });
  }

  void _onProductTap(ProductSearchResult product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: product.id),
      ),
    );
  }

  void _onCategoryTap(CategorySearchResult category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatalogDetailScreen(
          categoryName: category.name,
          categoryId: category.id,
          filterParams: {
            'categoryId': category.id,
            'categoryName': category.name,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _searchProvider,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.45),
        body: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.chevron_left_rounded),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    onChanged: _onChanged,
                                    decoration: InputDecoration(
                                      hintText:
                                          widget.mode == SearchMode.products
                                          ? 'Tìm sản phẩm...'
                                          : 'Tìm danh mục...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Consumer<SearchProvider>(
                              builder: (context, provider, _) {
                                if (provider.isSearching) {
                                  return const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                if (provider.productResults.isEmpty &&
                                    provider.categoryResults.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      _controller.text.trim().isEmpty
                                          ? 'Nhập để tìm kiếm...'
                                          : 'Không tìm thấy kết quả',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  );
                                }

                                return ConstrainedBox(
                                  constraints: const BoxConstraints(),
                                  child: ListView(
                                    // quan trọng: cho phép list cao theo nội dung
                                    shrinkWrap: true,
                                    // nếu muốn tắt scroll vì item ít:
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      if (widget.mode ==
                                              SearchMode.categories &&
                                          provider.categoryResults.isNotEmpty)
                                        ...provider.categoryResults.map(
                                          (c) => ListTile(
                                            leading: _CategoryAvatar(
                                              url: FileUtils.fixImgUrl(
                                                c.imageUrl!,
                                              ),
                                            ),
                                            title: Text(c.name),
                                            onTap: () => _onCategoryTap(c),
                                          ),
                                        ),
                                      if (widget.mode == SearchMode.products &&
                                          provider.productResults.isNotEmpty)
                                        ...provider.productResults.map(
                                          (p) => ListTile(
                                            leading: _CategoryAvatar(
                                              url: FileUtils.fixImgUrl(
                                                p.imageUrl!,
                                              ),
                                            ),
                                            title: Text(p.name),
                                            onTap: () => _onProductTap(p),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryAvatar extends StatelessWidget {
  const _CategoryAvatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Colors.black12,
        child: Icon(Icons.category_outlined, color: Colors.black54),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(url!),
      backgroundColor: Colors.transparent,
    );
  }
}
