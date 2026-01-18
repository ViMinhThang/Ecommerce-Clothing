import 'package:flutter/material.dart';

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
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            colorName,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
