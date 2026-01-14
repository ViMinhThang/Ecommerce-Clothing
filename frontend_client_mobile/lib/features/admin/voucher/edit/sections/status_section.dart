import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class VoucherStatusSection extends StatelessWidget {
  final String status;
  final ValueChanged<String> onStatusChanged;

  const VoucherStatusSection({
    super.key,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Status',
      children: [
        AdminStatusToggle(
          currentStatus: status,
          onChanged: onStatusChanged,
          options: const [
            StatusOption(value: 'ACTIVE', label: 'Active'),
            StatusOption(value: 'INACTIVE', label: 'Inactive'),
          ],
        ),
      ],
    );
  }
}
