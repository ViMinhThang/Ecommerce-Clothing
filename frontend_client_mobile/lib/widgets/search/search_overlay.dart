import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/models/product_search_result.dart';
import 'package:frontend_client_mobile/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final bool includeCategories;
  final bool includeProducts;
  final int? categoryId;
  final ValueChanged<ProductSearchResult>? onProductTap;
  final ValueChanged<CategorySearchResult>? onCategoryTap;
  final String hintText;

  const SearchOverlay({
    super.key,
    required this.onClose,
    this.includeCategories = true,
    this.includeProducts = true,
    this.categoryId,
    this.onProductTap,
    this.onCategoryTap,
    this.hintText = 'Tìm kiếm...',
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<SearchProvider>().search(
        value,
        categoryId: widget.categoryId,
        includeCategories: widget.includeCategories,
        includeProducts: widget.includeProducts,
      );
    });
  }

  void _closeOverlay() {
    _controller.clear();
    context.read<SearchProvider>().clear();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.black.withOpacity(0.55),
      child: Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: _closeOverlay)),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: GestureDetector(
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      minHeight: 280,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    onChanged: _onChanged,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.search_rounded,
                                      ),
                                      hintText: widget.hintText,
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  onPressed: _closeOverlay,
                                  icon: const Icon(Icons.close_rounded),
                                  tooltip: 'Đóng',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Consumer<SearchProvider>(
                                builder: (context, provider, _) {
                                  if (provider.isSearching) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }

                                  if ((_controller.text.trim().isEmpty) &&
                                      provider.productResults.isEmpty &&
                                      provider.categoryResults.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Nhập để tìm kiếm sản phẩm hoặc danh mục',
                                        style: theme.textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  if (provider.productResults.isEmpty &&
                                      provider.categoryResults.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Không tìm thấy kết quả phù hợp',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    );
                                  }

                                  return ListView(
                                    children: [
                                      if (widget.includeCategories &&
                                          provider.categoryResults.isNotEmpty)
                                        _SearchSection<CategorySearchResult>(
                                          title: 'Danh mục',
                                          items: provider.categoryResults,
                                          itemBuilder: (context, category) =>
                                              ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: const Color(
                                                    0xFFE6E8EB,
                                                  ),
                                                  backgroundImage:
                                                      category.image != null &&
                                                          category
                                                              .image!
                                                              .isNotEmpty
                                                      ? NetworkImage(
                                                          category.image!,
                                                        )
                                                      : null,
                                                  child:
                                                      category.image == null ||
                                                          category
                                                              .image!
                                                              .isEmpty
                                                      ? Text(
                                                          category
                                                                  .name
                                                                  .isNotEmpty
                                                              ? category.name[0]
                                                                    .toUpperCase()
                                                              : '?',
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        )
                                                      : null,
                                                ),
                                                title: Text(category.name),
                                                trailing: const Icon(
                                                  Icons.north_east,
                                                  size: 16,
                                                ),
                                                onTap: () {
                                                  _closeOverlay();
                                                  widget.onCategoryTap?.call(
                                                    category,
                                                  );
                                                },
                                              ),
                                        ),
                                      if (widget.includeProducts &&
                                          provider.productResults.isNotEmpty)
                                        _SearchSection<ProductSearchResult>(
                                          title: 'Sản phẩm',
                                          items: provider.productResults,
                                          itemBuilder: (context, product) =>
                                              ListTile(
                                                leading: _ProductLeading(
                                                  thumbnail: product.thumbnail,
                                                ),
                                                title: Text(product.name),
                                                subtitle: product.price != null
                                                    ? Text(
                                                        _formatCurrency(
                                                          product.price!,
                                                        ),
                                                        style: theme
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                      )
                                                    : null,
                                                onTap: () {
                                                  _closeOverlay();
                                                  widget.onProductTap?.call(
                                                    product,
                                                  );
                                                },
                                              ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      final millions = value / 1000000;
      return '${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 1)} triệu';
    }
    if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)} nghìn';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
  }
}

class _SearchSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const _SearchSection({
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        ...items.map((item) => itemBuilder(context, item)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ProductLeading extends StatelessWidget {
  final String? thumbnail;

  const _ProductLeading({this.thumbnail});

  @override
  Widget build(BuildContext context) {
    if (thumbnail == null || thumbnail!.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFE6E8EB),
        child: Icon(Icons.image_outlined, color: Colors.black54),
      );
    }
    return CircleAvatar(backgroundImage: NetworkImage(thumbnail!));
  }
}
