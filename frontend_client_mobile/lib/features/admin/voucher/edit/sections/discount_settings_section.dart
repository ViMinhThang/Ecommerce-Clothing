import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';
import '../widgets/discount_type_widgets.dart';

class DiscountSettingsSection extends StatelessWidget {
  final String discountType;
  final TextEditingController discountValueController;
  final TextEditingController maxDiscountController;
  final ValueChanged<String> onDiscountTypeChanged;

  const DiscountSettingsSection({
    super.key,
    required this.discountType,
    required this.discountValueController,
    required this.maxDiscountController,
    required this.onDiscountTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Discount Settings',
      children: [
        const DiscountTypeLabel(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DiscountTypeOption(
                type: 'PERCENTAGE',
                label: 'Percentage',
                icon: Icons.percent,
                currentType: discountType,
                onChanged: onDiscountTypeChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DiscountTypeOption(
                type: 'FIXED_AMOUNT',
                label: 'Fixed',
                icon: Icons.attach_money,
                currentType: discountType,
                onChanged: onDiscountTypeChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminInputField(
                controller: discountValueController,
                label: discountType == 'PERCENTAGE'
                    ? 'Value (%)'
                    : 'Amount (\$)',
                hint: '0',
                icon: Icons.add_circle_outline,
                keyboardType: TextInputType.number,
              ),
            ),
            if (discountType == 'PERCENTAGE') ...[
              const SizedBox(width: 16),
              Expanded(
                child: AdminInputField(
                  controller: maxDiscountController,
                  label: 'Cap (\$)',
                  hint: '0',
                  icon: Icons.keyboard_arrow_up,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
