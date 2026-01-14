import 'package:flutter/foundation.dart';
import 'package:frontend_client_mobile/models/review.dart';
import 'package:frontend_client_mobile/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  List<Review> _productReviews = [];
  List<Review> _userReviews = [];
  ProductReviewSummary? _productSummary;
  Set<int> _reviewedOrderItemIds = {};

  bool _isLoading = false;
  String? _error;

  List<Review> get productReviews => _productReviews;
  List<Review> get userReviews => _userReviews;
  ProductReviewSummary? get productSummary => _productSummary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isOrderItemReviewed(int orderItemId) {
    return _reviewedOrderItemIds.contains(orderItemId);
  }

  Future<void> loadProductReviews(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _reviewService.getProductReviews(
        productId: productId,
      );
      _productReviews = response.content;
      _productSummary = await _reviewService.getProductReviewSummary(productId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserReviews(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _reviewService.getUserReviews(userId: userId);
      _userReviews = response.content;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReviewedOrderItemIds(int orderId) async {
    try {
      final ids = await _reviewService.getReviewedOrderItemIds(orderId);
      _reviewedOrderItemIds = ids.toSet();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reviewed items: $e');
    }
  }

  Future<bool> canReview(int userId, int orderItemId) async {
    return await _reviewService.canReview(
      userId: userId,
      orderItemId: orderItemId,
    );
  }

  Future<Review?> createReview({
    required int userId,
    required int orderItemId,
    required int rating,
    String? comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final review = await _reviewService.createReview(
        userId: userId,
        orderItemId: orderItemId,
        rating: rating,
        comment: comment,
      );
      _reviewedOrderItemIds.add(orderItemId);
      _isLoading = false;
      notifyListeners();
      return review;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearProductReviews() {
    _productReviews = [];
    _productSummary = null;
    notifyListeners();
  }
}
