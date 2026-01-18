import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/stock_check_response.dart';

class StockStatusBadge extends StatelessWidget {
  final StockCheckResponse? stockInfo;
  final bool showCount;

  const StockStatusBadge({
    super.key,
    required this.stockInfo,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    if (stockInfo == null) {
      return const SizedBox.shrink();
    }

    Color badgeColor;
    String badgeText;
    IconData icon;

    switch (stockInfo!.stockStatus) {
      case 'OUT_OF_STOCK':
        badgeColor = Colors.red;
        badgeText = 'Out of Stock';
        icon = Icons.remove_circle_outline;
        break;
      case 'LOW_STOCK':
        badgeColor = Colors.orange;
        badgeText = showCount
            ? 'Only ${stockInfo!.availableStock} left'
            : 'Low Stock';
        icon = Icons.warning_amber_outlined;
        break;
      case 'IN_STOCK':
      default:
        if (showCount && stockInfo!.availableStock < 50) {
          badgeColor = Colors.green;
          badgeText = '${stockInfo!.availableStock} available';
          icon = Icons.check_circle_outline;
        } else {
          badgeColor = Colors.green;
          badgeText = 'In Stock';
          icon = Icons.check_circle_outline;
        }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
