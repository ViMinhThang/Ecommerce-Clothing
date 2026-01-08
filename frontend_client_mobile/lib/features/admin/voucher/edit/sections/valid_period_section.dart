import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';
import '../widgets/date_picker_field.dart';

class ValidPeriodSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;

  const ValidPeriodSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Valid Period',
      children: [
        Row(
          children: [
            Expanded(
              child: DatePickerField(
                label: 'Start Date',
                date: startDate,
                onSelect: onStartDateChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DatePickerField(
                label: 'End Date',
                date: endDate,
                onSelect: onEndDateChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
