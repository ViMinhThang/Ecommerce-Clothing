// import 'package:flutter/material.dart';
// import '../../../../controller/product_controller.dart';

// import 'package:provider/provider.dart';

// class CatalogDetailScreen extends StatefulWidget {
//   const CatalogDetailScreen({super.key});

//   @override
//   State<CatalogDetailScreen> createState() => _CatalogDetailScreenState();
// }

// class _CatalogDetailScreenState extends State<CatalogDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProductController>().fetchProducts();
//     });
//   }

//   // int _bottomIndex = 1; // Catalog tab selected
//   bool _popular = true;

//   @override
//   Widget build(BuildContext context) {
//     final padding = MediaQuery.paddingOf(context);
//     final productController = context.watch<ProductController>();
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 56,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Catalog',
//           style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           // Thanh filter/sort dạng chips
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
//               child: Row(
//                 children: [
//                   _ChipButton(
//                     icon: Icons.filter_list_rounded,
//                     label: 'Filter',
//                     onTap: () async {
//                       await Navigator.pushNamed(context, "/filter");
//                     },
//                   ),
//                   const SizedBox(width: 10),
//                   _ChipButton(
//                     icon: Icons.sort_rounded,
//                     label: _popular ? 'Popular' : 'Newest',
//                     onTap: () => setState(() => _popular = !_popular),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     visualDensity: VisualDensity.compact,
//                     onPressed: () {},
//                     icon: const Icon(Icons.tune_rounded),
//                     tooltip: 'More',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Lưới 2 cột
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 return ProductCard(product: productController.products[index]);
//               }, childCount: productController.products.length),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//                 childAspectRatio: 0.65,
//                 // Chiều cao item: ảnh 3/4 + phần text => tăng slightly
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(child: SizedBox(height: padding.bottom + 8)),
//         ],
//       ),
//     );
//   }
// }

// class _ChipButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _ChipButton({required this.icon, required this.label, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 18),
//       label: Text(label),
//       style: OutlinedButton.styleFrom(
//         visualDensity: VisualDensity.compact,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }
