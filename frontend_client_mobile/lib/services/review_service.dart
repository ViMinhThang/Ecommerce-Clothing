import 'package:frontend_client_mobile/models/page_response.dart';
import 'package:frontend_client_mobile/models/review.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/review_api_service.dart';

class ReviewService {
  final ReviewApiService _apiService = ApiClient.getReviewApiService();

  Future<Review> createReview({
    required int userId,
    required int orderItemId,
    required int rating,
    String? comment,
  }) async {
    final request = {
      'orderItemId': orderItemId,
      'rating': rating,
      'comment': comment,
    };
    return await _apiService.createReview(userId, request);
  }

  Future<bool> canReview({
    required int userId,
    required int orderItemId,
  }) async {
    try {
      final response = await _apiService.canReview(orderItemId, userId);
      final data = response.data;
      if (data is Map) {
        return data['canReview'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<PageResponse<Review>> getProductReviews({
    required int productId,
    int page = 0,
    int size = 10,
  }) async {
    return await _apiService.getProductReviews(productId, page, size);
  }

  Future<ProductReviewSummary> getProductReviewSummary(int productId) async {
    return await _apiService.getProductReviewSummary(productId);
  }

  Future<PageResponse<Review>> getUserReviews({
    required int userId,
    int page = 0,
    int size = 10,
  }) async {
    return await _apiService.getUserReviews(userId, page, size);
  }

  Future<List<int>> getReviewedOrderItemIds(int orderId) async {
    final response = await _apiService.getReviewedOrderItemIds(orderId);
    final data = response.data;
    if (data is List) {
      return data.map((e) => e as int).toList();
    }
    return [];
  }
}
