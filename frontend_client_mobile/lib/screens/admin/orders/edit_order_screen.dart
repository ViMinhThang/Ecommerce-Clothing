import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme_config.dart';
import '../../../models/order_view.dart';
import '../base/base_edit_screen.dart';

class EditOrderScreen extends BaseEditScreen<OrderView> {
  const EditOrderScreen({super.key, super.entity});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState
    extends BaseEditScreenState<OrderView, EditOrderScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _customerController;
  late final TextEditingController _totalController;
  late final TextEditingController _dateController;
  String _status = 'pending';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void disposeControllers() {
    _animationController.dispose();
    _customerController.dispose();
    _totalController.dispose();
    _dateController.dispose();
  }

  @override
  String getScreenTitle() => isEditing ? 'Edit Order' : 'New Order';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'Order';

  @override
  IconData getSectionIcon() => Icons.inventory_2_outlined;

  @override
  void initializeForm() {
    _customerController = TextEditingController(
      text: widget.entity?.buyerEmail ?? '',
    );
    _totalController = TextEditingController(
      text: widget.entity?.totalPrice.toString() ?? '',
    );
    _dateController = TextEditingController(
      text: widget.entity?.createdDate ?? '',
    );
    _status = widget.entity?.status ?? 'pending';
  }

  @override
  bool validateForm() {
    return _customerController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final order = OrderView(
      id: widget.entity?.id ?? DateTime.now().millisecondsSinceEpoch,
      buyerEmail: _customerController.text.trim(),
      totalPrice: double.tryParse(_totalController.text) ?? 0,
      createdDate: _dateController.text.trim(),
      status: _status,
    );

    Navigator.pop(context, order);
  }

  @override
  Widget buildHeaderImage() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: _TechnicalPatternPainter()),
            ),
          ),

          // Main Title
          Positioned(
            left: 24,
            top: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Management',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing ? 'Edit Order' : 'New Order',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Floating ID Badge
          if (isEditing)
            Positioned(right: 24, bottom: -30, child: _buildIdBadge()),

          // Decorative Lines
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(height: 1, color: Colors.white10),
          ),
        ],
      ),
    );
  }

  Widget _buildIdBadge() {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
    );
    return ScaleTransition(
      scale: animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Order ID',
              style: GoogleFonts.outfit(
                color: Colors.black38,
                fontSize: 8,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '#${widget.entity?.id.toString().padLeft(4, '0')}',
              style: GoogleFonts.bebasNeue(
                color: Colors.black,
                fontSize: 32,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildSectionHeader('Order Details'),
        _buildAnimatedField(
          index: 0,
          child: _buildTextField(
            controller: _customerController,
            label: 'Customer Email',
            icon: Icons.alternate_email_rounded,
            hint: 'e.g. customer@example.com',
          ),
        ),
        const SizedBox(height: 24),
        _buildAnimatedField(
          index: 1,
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _totalController,
                  label: 'Total Amount (₫)',
                  icon: Icons.payments_outlined,
                  keyboard: TextInputType.number,
                  hint: 'PRICE IN VND',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _dateController,
                  label: 'Order Date',
                  icon: Icons.event_note_rounded,
                  hint: 'YYYY-MM-DD',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildSectionHeader('Order Status'),
        _buildAnimatedField(
          index: 2,
          child: _StatusSelector(
            currentStatus: _status,
            onChanged: (val) => setState(() => _status = val),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.black12, fontSize: 13),
            prefixIcon: Icon(icon, size: 18, color: Colors.black26),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusSM,
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedField({required int index, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (0.2 + (index * 0.1)).clamp(0, 1.0),
        (0.7 + (index * 0.1)).clamp(0, 1.0),
        curve: Curves.easeOutQuart,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String currentStatus;
  final Function(String) onChanged;

  const _StatusSelector({required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {
        'id': 'pending',
        'icon': Icons.hourglass_empty_rounded,
        'color': Colors.amber,
      },
      {
        'id': 'processing',
        'icon': Icons.swap_calls_rounded,
        'color': Colors.indigo,
      },
      {
        'id': 'completed',
        'icon': Icons.verified_rounded,
        'color': const Color(0xFF10B981),
      },
      {
        'id': 'cancelled',
        'icon': Icons.do_disturb_on_rounded,
        'color': const Color(0xFFEF4444),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: statuses.map((status) {
          final isSelected = currentStatus == status['id'];
          final color = status['color'] as Color;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(status['id'] as String),
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
                      status['icon'] as IconData,
                      size: 20,
                      color: isSelected ? Colors.white : Colors.black26,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (status['id'] as String).toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : Colors.black26,
                        letterSpacing: 1,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
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

class _TechnicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    // Grid lines
    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Diagonal lines
    paint.color = Colors.white.withValues(alpha: 0.1);
    for (var i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Circles
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      60,
      paint..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      4,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
