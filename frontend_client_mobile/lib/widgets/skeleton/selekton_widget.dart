import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white, // Bắt buộc phải có màu
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: Colors.white, // Bắt buộc phải có màu
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Giả lập dòng mô tả ngắn hơn
                  Container(
                    width: 200.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                   // Giả lập dòng mô tả ngắn nữa
                  Container(
                    width: 150.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}