import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/thanh/controller/product_controller.dart';
import 'package:frontend_client_mobile/thanh/screens/product/product_card_component.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = context.watch<ProductController>();
    final base = Theme.of(context);
    final screenTheme = base.copyWith(
      textTheme: GoogleFonts.loraTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.lora(
          textStyle: base.textTheme.titleLarge?.copyWith(
            color: base.colorScheme.onPrimary,
          ),
        ),
      ),
    );
    return Theme(
      data: screenTheme,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Eleven', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 70,
                      height: 150,
                      color: Colors.grey[300],
                      child: Image.network(
                        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&w=70&h=100&fit=crop',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: const Color(0xFFBFC7CE),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              'Brand New\nCOLLECTION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Image.network(
                          'https://images.pexels.com/photos/532220/pexels-photo-532220.jpeg?auto=compress&w=200&h=120&fit=crop',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Categories row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          _CategoryChip(label: 'All'),
                          _CategoryChip(label: 'Dresses'),
                          _CategoryChip(label: 'Jackets & Blazers'),
                          _CategoryChip(label: 'Coats'),
                          _CategoryChip(label: 'Skirts'),
                          _CategoryChip(label: 'Tops'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: productController.products[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Category chip widget
class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(label, style: TextStyle(fontSize: 20)),
    );
  }
}
