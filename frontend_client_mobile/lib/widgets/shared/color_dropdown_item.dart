import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class ColorDropdownItem extends StatelessWidget {
  final String colorName;
  final Color color;

  const ColorDropdownItem({
    super.key,
    required this.colorName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.veryLightGray, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(child: Text(colorName, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
