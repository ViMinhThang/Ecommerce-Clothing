import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class OrderStatus {
  static const String pending = 'pending';
  static const String processing = 'processing';
  static const String delivered = 'delivered';

  static const List<OrderStatusOption> options = [
    OrderStatusOption(
      id: pending,
      icon: Icons.hourglass_empty_rounded,
      color: Colors.amber,
    ),
    OrderStatusOption(
      id: processing,
      icon: Icons.swap_calls_rounded,
      color: Colors.indigo,
    ),
    OrderStatusOption(
      id: delivered,
      icon: Icons.local_shipping_rounded,
      color: Color(0xFF10B981),
    ),
  ];
}

class OrderStatusOption {
  final String id;
  final IconData icon;
  final Color color;

  const OrderStatusOption({
    required this.id,
    required this.icon,
    required this.color,
  });
}

class OrderStatusSection extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onStatusChanged;

  const OrderStatusSection({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Order Status',
      children: [
        _StatusSelector(
          currentStatus: currentStatus,
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onChanged;

  const _StatusSelector({required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: OrderStatus.options.map((status) {
          final isSelected = currentStatus == status.id;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(status.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: AppTheme.borderRadiusXS,
                ),
                child: Column(
                  children: [
                    Icon(
                      status.icon,
                      color: isSelected ? status.color : Colors.black26,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.id.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : Colors.black26,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
