import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final List<DropdownMenuItem<String>> items;
  final String label;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.label = 'Status',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
