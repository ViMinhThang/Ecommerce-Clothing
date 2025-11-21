import 'package:flutter/material.dart';
import '../../../../controller/catalog_controller.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Debug: đảm bảo initState thực sự chạy
    // Nếu không thấy log này trong console => app chưa dùng màn hình này
    // -> kiểm tra main.dart xem home có trỏ tới CatalogScreen chưa.
    // -> kiểm tra Navigator.push bạn đang mở màn hình nào.
    // ignore: avoid_print
    print('CatalogScreen.initState -> fetchProducts()');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogController>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CatalogController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        centerTitle: true,
        title: const Text(
          'Catalog',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          }
          if (controller.catalog_cards.isEmpty) {
            return const Center(child: Text('No data'));
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: controller.catalog_cards.length,
            itemBuilder: (context, index) {
              final e = controller.catalog_cards[index];
              return _CatalogCard(title: e.title, imageUrl: e.imageUrl);
            },
          );
        },
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const _CatalogCard({required this.title, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Dùng Image.network có errorBuilder để tránh ô trắng nếu ảnh lỗi
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade300),
                ),
                // Ripple
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(context, "/details");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
