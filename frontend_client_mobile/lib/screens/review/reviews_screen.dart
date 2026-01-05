import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/review.dart';
import 'package:frontend_client_mobile/providers/review_provider.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/screens/product/product.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final userId = await TokenStorage().readUserId();
    if (userId != null) {
      Provider.of<ReviewProvider>(context, listen: false).loadUserReviews(userId);
    }
  }

  void _onNavItemTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(initialTab: index)),
      (route) => false,
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 18,
            color: index < rating ? Colors.amber : Colors.grey[300],
          );
        }),
        const SizedBox(width: 6),
        Text(
          '$rating.0',
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: review.productId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: review.productImageUrl != null
                          ? Image.network(
                              review.productImageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[100],
                                child: Icon(Icons.image, color: Colors.grey[400]),
                              ),
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[100],
                              child: Icon(Icons.image, color: Colors.grey[400]),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.productName,
                          style: GoogleFonts.lora(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _buildStars(review.rating),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              '${review.createdDate.day}/${review.createdDate.month}/${review.createdDate.year}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow indicator
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
                ],
              ),
            ),
            // Comment section
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              Divider(height: 1, color: Colors.grey[200]),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.format_quote_rounded, size: 20, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        review.comment!,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Reviews',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.userReviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadReviews,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.userReviews.length,
              itemBuilder: (context, index) {
                return _buildReviewCard(provider.userReviews[index]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer2<CartProvider, WishlistProvider>(
        builder: (context, cartProvider, wishlistProvider, child) {
          final cartItemCount = cartProvider.cart?.items.length ?? 0;
          final wishlistItemCount = wishlistProvider.itemCount;

          return BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: wishlistItemCount > 0,
                  label: Text(
                    wishlistItemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.favorite_border),
                ),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: cartItemCount > 0,
                  label: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            currentIndex: 4,
            onTap: _onNavItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
