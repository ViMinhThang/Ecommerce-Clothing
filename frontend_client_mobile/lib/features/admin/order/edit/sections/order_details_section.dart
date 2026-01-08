import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class OrderDetailsSection extends StatelessWidget {
  final TextEditingController customerController;
  final TextEditingController totalController;
  final TextEditingController dateController;

  const OrderDetailsSection({
    super.key,
    required this.customerController,
    required this.totalController,
    required this.dateController,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Order Details',
      children: [
        AdminInputField(
          controller: customerController,
          label: 'Customer Email',
          icon: Icons.alternate_email_rounded,
          hint: 'e.g. customer@example.com',
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AdminInputField(
                controller: totalController,
                label: 'Total Amount (₫)',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                hint: 'Price in VND',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminInputField(
                controller: dateController,
                label: 'Order Date',
                icon: Icons.event_note_rounded,
                hint: 'YYYY-MM-DD',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
