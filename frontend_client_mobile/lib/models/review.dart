class Review {
  final int id;
  final int userId;
  final String userName;
  final int productId;
  final String productName;
  final String? productImageUrl;
  final int orderId;
  final int orderItemId;
  final int rating;
  final String? comment;
  final String status;
  final DateTime createdDate;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.orderId,
    required this.orderItemId,
    required this.rating,
    this.comment,
    required this.status,
    required this.createdDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      productImageUrl: json['productImageUrl'],
      orderId: json['orderId'] ?? 0,
      orderItemId: json['orderItemId'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      status: json['status'] ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'orderId': orderId,
      'orderItemId': orderItemId,
      'rating': rating,
      'comment': comment,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}

class ProductReviewSummary {
  final int productId;
  final double averageRating;
  final int totalReviews;

  ProductReviewSummary({
    required this.productId,
    required this.averageRating,
    required this.totalReviews,
  });

  factory ProductReviewSummary.fromJson(Map<String, dynamic> json) {
    return ProductReviewSummary(
      productId: json['productId'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class CreateReviewRequest {
  final int orderItemId;
  final int rating;
  final String? comment;

  CreateReviewRequest({
    required this.orderItemId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'rating': rating,
      'comment': comment,
    };
  }
}
