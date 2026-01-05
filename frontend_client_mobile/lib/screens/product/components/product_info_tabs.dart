import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/product_detail_provider.dart';
import 'package:frontend_client_mobile/models/review.dart';
import 'package:frontend_client_mobile/services/review_service.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInfoTabs extends StatefulWidget {
  const ProductInfoTabs({super.key});

  @override
  State<ProductInfoTabs> createState() => _ProductInfoTabsState();
}

class _ProductInfoTabsState extends State<ProductInfoTabs> {
  final ReviewService _reviewService = ReviewService();
  List<Review> _reviews = [];
  ProductReviewSummary? _summary;
  bool _isLoadingReviews = false;
  bool _reviewsExpanded = false;

  Future<void> _loadReviews(int productId) async {
    if (_isLoadingReviews) return;
    setState(() => _isLoadingReviews = true);

    try {
      final summary = await _reviewService.getProductReviewSummary(productId);
      final response = await _reviewService.getProductReviews(productId: productId, size: 5);
      setState(() {
        _summary = summary;
        _reviews = response.content;
      });
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    } finally {
      setState(() => _isLoadingReviews = false);
    }
  }

  Widget _buildStars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star_rounded, size: size, color: Colors.amber);
        } else if (index < rating) {
          return Icon(Icons.star_half_rounded, size: size, color: Colors.amber);
        } else {
          return Icon(Icons.star_outline_rounded, size: size, color: Colors.grey[300]);
        }
      }),
    );
  }

  Widget _buildReviewSummary() {
    if (_summary == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                _summary!.averageRating.toStringAsFixed(1),
                style: GoogleFonts.lora(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              _buildStars(_summary!.averageRating, size: 18),
              const SizedBox(height: 4),
              Text(
                '${_summary!.totalReviews} reviews',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starNum = 5 - index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$starNum',
                        style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.0, // Could calculate from API if breakdown available
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        _buildStars(review.rating.toDouble(), size: 14),
                        const SizedBox(width: 8),
                        Text(
                          '${review.createdDate.day}/${review.createdDate.month}/${review.createdDate.year}',
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.comment!,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    if (_isLoadingReviews) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.rate_review_outlined, size: 40, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(
                'No reviews yet',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 4),
              Text(
                'Be the first to review this product!',
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildReviewSummary(),
        ..._reviews.map((review) => _buildReviewCard(review)),
        if (_summary != null && _summary!.totalReviews > 5)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextButton(
              onPressed: () {
                // Could navigate to full reviews page
              },
              child: Text(
                'View all ${_summary!.totalReviews} reviews',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);
    final productId = provider.product?.id;

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Description',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: provider.isLoadingProduct
                    ? const Text('Loading description...')
                    : Text(
                        provider.product?.description ??
                            'No description available',
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
              ),
            ],
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Customer Reviews',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: (expanded) {
              if (expanded && !_reviewsExpanded && productId != null) {
                _reviewsExpanded = true;
                _loadReviews(productId);
              }
            },
            children: [
              _buildReviewsList(),
            ],
          ),
        ),
      ],
    );
  }
}

