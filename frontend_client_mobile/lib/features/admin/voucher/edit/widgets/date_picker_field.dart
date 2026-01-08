import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onSelect;

  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onSelect,
  });

  static final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 10),
        _buildPickerButton(context),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: AppTheme.borderRadiusXS,
          ),
          child: const Icon(Icons.event, size: 14, color: Colors.black54),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPickerButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
          borderRadius: AppTheme.borderRadiusXS,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null
                    ? _dateFormat.format(date!).toUpperCase()
                    : 'Select Date',
                style: GoogleFonts.outfit(
                  color: date != null ? Colors.black87 : Colors.black26,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
