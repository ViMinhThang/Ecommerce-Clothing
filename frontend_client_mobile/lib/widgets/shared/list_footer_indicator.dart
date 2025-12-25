import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class ListFooterIndicator extends StatelessWidget {
  final bool isLoading;
  final String endMessage;

  const ListFooterIndicator({
    super.key,
    this.isLoading = false,
    this.endMessage = 'You\'ve reached the end',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: AppTheme.primaryBlack,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              endMessage,
              style: AppTheme.caption.copyWith(
                color: AppTheme.mediumGray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
