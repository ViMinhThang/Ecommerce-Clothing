import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class UsageLimitsSection extends StatelessWidget {
  final TextEditingController minOrderController;
  final TextEditingController usageLimitController;

  const UsageLimitsSection({
    super.key,
    required this.minOrderController,
    required this.usageLimitController,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Usage Limits',
      children: [
        AdminInputField(
          controller: minOrderController,
          label: 'Minimum Purchase (\$)',
          hint: '0',
          icon: Icons.shopping_bag_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        AdminInputField(
          controller: usageLimitController,
          label: 'Usage Limit',
          hint: '0 = Unlimited',
          icon: Icons.person_outline,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
