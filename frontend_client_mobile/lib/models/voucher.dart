class Voucher {
  final int id;
  final String code;
  final String? description;
  final String discountType;
  final double discountValue;
  final double minOrderAmount;
  final double maxDiscountAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final int usageLimit;
  final int usedCount;
  final String status;
  final DateTime? createdDate;

  Voucher({
    required this.id,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscountAmount,
    this.startDate,
    this.endDate,
    required this.usageLimit,
    required this.usedCount,
    required this.status,
    this.createdDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'],
      discountType: json['discountType'] ?? 'PERCENTAGE',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      minOrderAmount: (json['minOrderAmount'] ?? 0).toDouble(),
      maxDiscountAmount: (json['maxDiscountAmount'] ?? 0).toDouble(),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      usageLimit: json['usageLimit'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'usageLimit': usageLimit,
      'status': status,
    };
  }

  bool get isPercentage => discountType == 'PERCENTAGE';
  bool get isActive => status == 'ACTIVE';
  
  String get discountDisplay {
    if (isPercentage) {
      return '${discountValue.toInt()}%';
    }
    return '\$${discountValue.toStringAsFixed(0)}';
  }
}

class ValidateVoucherResponse {
  final bool valid;
  final String message;
  final int? voucherId;
  final String? code;
  final String? discountType;
  final double discountValue;
  final double discountAmount;
  final double finalPrice;

  ValidateVoucherResponse({
    required this.valid,
    required this.message,
    this.voucherId,
    this.code,
    this.discountType,
    required this.discountValue,
    required this.discountAmount,
    required this.finalPrice,
  });

  factory ValidateVoucherResponse.fromJson(Map<String, dynamic> json) {
    return ValidateVoucherResponse(
      valid: json['valid'] ?? false,
      message: json['message'] ?? '',
      voucherId: json['voucherId'],
      code: json['code'],
      discountType: json['discountType'],
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
    );
  }
}
