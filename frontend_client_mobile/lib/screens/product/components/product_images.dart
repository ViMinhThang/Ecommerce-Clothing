import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:provider/provider.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({super.key});

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    _pageController = PageController(initialPage: provider.currentImageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 450,
          color: const Color(0xFFF5F5F5),
          child: provider.isLoadingProduct
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        provider.setCurrentImageIndex(index);
                      },
                      itemCount: provider.productImageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          provider.productImageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    if (provider.productImageUrls.length > 1)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            provider.productImageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: provider.currentImageIndex == index
                                  ? 24
                                  : 8,
                              decoration: BoxDecoration(
                                color: provider.currentImageIndex == index
                                    ? Colors.black
                                    : Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialTab: 1),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
