import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class SizeFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final String status;
  final ValueChanged<String> onStatusChanged;

  const SizeFormSection({
    super.key,
    required this.nameController,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Size Details',
      children: [
        AdminInputField(
          controller: nameController,
          label: 'Size Name',
          hint: 'e.g. XL, 42, Large',
          icon: Icons.straighten,
        ),
        const SizedBox(height: 24),
        AdminStatusToggle(currentStatus: status, onChanged: onStatusChanged),
      ],
    );
  }
}
