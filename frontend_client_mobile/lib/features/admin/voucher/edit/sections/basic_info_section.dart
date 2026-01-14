import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class VoucherBasicInfoSection extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController descriptionController;

  const VoucherBasicInfoSection({
    super.key,
    required this.codeController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Basic Information',
      children: [
        AdminInputField(
          controller: codeController,
          label: 'Voucher Code',
          hint: 'e.g. SUMMER50',
          icon: Icons.tag,
        ),
        const SizedBox(height: 24),
        AdminInputField(
          controller: descriptionController,
          label: 'Description',
          hint: 'e.g. Get 50% off on all items',
          icon: Icons.description_outlined,
          maxLines: 2,
        ),
      ],
    );
  }
}
