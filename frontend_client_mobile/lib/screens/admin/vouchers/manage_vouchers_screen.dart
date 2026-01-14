import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:frontend_client_mobile/screens/admin/vouchers/edit_voucher_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/admin_list_item.dart';
import '../../../widgets/shared/confirmation_dialog.dart';
import '../base/base_manage_screen.dart';

class ManageVouchersScreen extends BaseManageScreen<Voucher> {
  const ManageVouchersScreen({super.key});

  @override
  State<ManageVouchersScreen> createState() => _ManageVouchersScreenState();
}

class _ManageVouchersScreenState
    extends BaseManageScreenState<Voucher, ManageVouchersScreen>
    with SingleTickerProviderStateMixin {
  VoucherProvider get _voucherProvider =>
      Provider.of<VoucherProvider>(context, listen: false);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  String getScreenTitle() => 'Brand Vouchers';

  @override
  int getSelectedIndex() => 7;

  @override
  String getEntityName() => 'voucher';

  @override
  IconData getEmptyStateIcon() => Icons.local_offer_outlined;

  @override
  String getSearchHint() => 'Search Voucher Code...';

  @override
  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _voucherProvider.loadVouchers().then((_) {
        if (mounted) _animationController.forward(from: 0);
      });
    });
  }

  @override
  void refreshData() {
    _voucherProvider.loadVouchers().then((_) {
      if (mounted) _animationController.forward(from: 0);
    });
  }

  @override
  List<Voucher> getItems() {
    return context.watch<VoucherProvider>().vouchers;
  }

  @override
  bool isLoading() {
    return context.watch<VoucherProvider>().isLoading;
  }

  @override
  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditVoucherScreen()),
    );
    _voucherProvider.loadVouchers();
  }

  @override
  Future<void> navigateToEdit(Voucher item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditVoucherScreen(entity: item)),
    );
    _voucherProvider.loadVouchers();
  }

  @override
  Future<void> handleDelete(Voucher item) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Confirm',
      message: 'Are you sure you want to delete voucher "${item.code}"?',
    );

    if (confirmed && mounted) {
      final success = await _voucherProvider.deleteVoucher(item.id);

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${item.code}"'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.primaryBlack,
          ),
        );
      }
    }
  }

  Widget _buildLeadingWidget(Voucher item) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipPath(
        clipper: _TicketClipper(),
        child: Container(
          color: const Color(0xFF111111),
          child: Stack(
            children: [
              // Noise/Pattern layer
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(painter: _VoucherPatternPainter()),
                ),
              ),
              // Diagonal shine
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      stops: const [0, 0.4, 1],
                    ),
                  ),
                ),
              ),
              // Vertical divider line (simulated tear)
              Positioned(
                right: 8,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 1,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.discountValue.toInt().toString(),
                        style: GoogleFonts.bebasNeue(
                          color: Colors.white,
                          fontSize: 26,
                          height: 1,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.isPercentage ? '%' : r'$',
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'OFF'.toUpperCase(),
                    style: GoogleFonts.montserrat(
                      color: Colors.white24,
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getItemTitle(Voucher item) => item.code.toUpperCase();

  Widget? _buildSubtitle(Voucher item) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final dateText = item.startDate != null && item.endDate != null
        ? '${dateFormat.format(item.startDate!)} - ${dateFormat.format(item.endDate!)}'
        : 'NO EXPIRY';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.description != null && item.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              item.description!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black45,
                height: 1.3,
                letterSpacing: 0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildStatusBadge(item.status),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 10,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    dateText.toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? Colors.black : Colors.black12,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: isActive ? Colors.white : Colors.black38,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget buildList() {
    final items = getItems();

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.1).clamp(0, 1.0),
            ((index * 0.1) + 0.5).clamp(0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: AdminListItem(
              leading: _buildLeadingWidget(item),
              title: _getItemTitle(item),
              subtitle: _buildSubtitle(item),
              onEdit: () => navigateToEdit(item),
              onDelete: () => handleDelete(item),
              editTooltip: 'Edit Voucher',
              deleteTooltip: 'Delete Voucher',
            ),
          ),
        );
      },
    );
  }
}

class _VoucherPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    const spacing = 4.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    const double radius = 14;
    const double punchRadius = 6;
    const double punchOffset = 56 / 2;

    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );

    // Right punch
    path.lineTo(size.width, punchOffset - punchRadius);
    path.arcToPoint(
      Offset(size.width, punchOffset + punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    // Left punch
    path.lineTo(0, punchOffset + punchRadius);
    path.arcToPoint(
      Offset(0, punchOffset - punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );

    path.lineTo(0, radius);
    path.arcToPoint(
      const Offset(radius, 0),
      radius: const Radius.circular(radius),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
