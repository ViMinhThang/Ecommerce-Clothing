import 'package:flutter/material.dart';
import 'dart:ui';
import '../../config/theme_config.dart';

class AdminDrawer extends StatefulWidget {
  final int selectedIndex;

  const AdminDrawer({super.key, required this.selectedIndex});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer>
    with TickerProviderStateMixin {
  late List<Animation<double>> _itemAnimations;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    const int itemCount = 7;
    _controllers = List.generate(
      itemCount,
      (index) =>
          AnimationController(duration: AppTheme.durationNormal, vsync: this),
    );

    _itemAnimations = List.generate(
      itemCount,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: AppTheme.curveEnter,
        ),
      ),
    );

    // Staggered animation
    for (int i = 0; i < itemCount; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      backgroundColor: AppTheme.background,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: AppTheme.spaceMD),
                _buildSectionLabel('MAIN'),
                _buildAnimatedItem(
                  0,
                  Icons.dashboard_outlined,
                  'Dashboard',
                  '/dashboard',
                  0,
                  5,
                ),
                _buildAnimatedItem(
                  1,
                  Icons.inventory_2_outlined,
                  'Products',
                  '/products',
                  1,
                  23,
                ),
                _buildAnimatedItem(
                  2,
                  Icons.shopping_bag_outlined,
                  'Orders',
                  '/orders',
                  2,
                  12,
                ),
                const SizedBox(height: AppTheme.spaceMD),
                _buildSectionLabel('MANAGEMENT'),
                _buildAnimatedItem(
                  3,
                  Icons.people_outline,
                  'Users',
                  '/users',
                  3,
                  null,
                ),
                _buildAnimatedItem(
                  4,
                  Icons.category_outlined,
                  'Categories',
                  '/categories',
                  4,
                  null,
                ),
                _buildAnimatedItem(
                  5,
                  Icons.straighten_outlined,
                  'Sizes',
                  '/sizes',
                  5,
                  null,
                ),
                _buildAnimatedItem(
                  6,
                  Icons.color_lens_outlined,
                  'Colors',
                  '/colors',
                  6,
                  null,
                ),
              ],
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        boxShadow: AppTheme.shadowMD,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with elegant white border
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryWhite, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryWhite.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: AppTheme.primaryWhite,
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                ),
              ),
              // Admin name
              const Text(
                'Admin Panel',
                style: TextStyle(
                  color: AppTheme.primaryWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppTheme.spaceXS),

              // Role badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceSM,
                  vertical: AppTheme.spaceXS,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryWhite.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: AppTheme.borderRadiusSM,
                ),
                child: const Text(
                  'Super Admin',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMD,
        vertical: AppTheme.spaceXS,
      ),
      child: Text(
        label,
        style: AppTheme.overline.copyWith(color: AppTheme.mediumGray),
      ),
    );
  }

  Widget _buildAnimatedItem(
    int animationIndex,
    IconData icon,
    String title,
    String route,
    int index,
    int? badgeCount,
  ) {
    return FadeTransition(
      opacity: _itemAnimations[animationIndex],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(_itemAnimations[animationIndex]),
        child: _DrawerItem(
          icon: icon,
          title: title,
          route: route,
          index: index,
          selectedIndex: widget.selectedIndex,
          badgeCount: badgeCount,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        border: Border(
          top: BorderSide(color: AppTheme.veryLightGray, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Stats display
            Text(
              '23 Products • 12 Orders',
              style: AppTheme.caption.copyWith(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            // Logout button
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // TODO: implement logout
              },
              borderRadius: AppTheme.borderRadiusSM,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMD,
                  vertical: AppTheme.spaceSM,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWhite,
                  border: AppTheme.borderThin,
                  borderRadius: AppTheme.borderRadiusSM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 18,
                      color: AppTheme.primaryBlack,
                    ),
                    const SizedBox(width: AppTheme.spaceSM),
                    Text(
                      'Logout',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceXS),
            // Version
            Text(
              'v1.0.0',
              style: AppTheme.caption.copyWith(
                color: AppTheme.lightGray,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String route;
  final int index;
  final int selectedIndex;
  final int? badgeCount;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.index,
    required this.selectedIndex,
    this.badgeCount,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  bool get _isSelected => widget.selectedIndex == widget.index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSM,
        vertical: AppTheme.spaceXS,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppTheme.durationNormal,
          curve: AppTheme.curveDefault,
          decoration: BoxDecoration(
            color: _isSelected
                ? AppTheme.primaryWhite
                : (_isHovered ? AppTheme.hoverOverlay : Colors.transparent),
            border: _isSelected
                ? Border(
                    left: BorderSide(color: AppTheme.primaryBlack, width: 3),
                  )
                : null,
            borderRadius: AppTheme.borderRadiusSM,
            boxShadow: _isSelected ? AppTheme.shadowSM : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                if (widget.selectedIndex != widget.index) {
                  Navigator.pushReplacementNamed(context, widget.route);
                }
              },
              borderRadius: AppTheme.borderRadiusSM,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMD,
                  vertical: AppTheme.spaceSM,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: _isSelected
                          ? AppTheme.primaryBlack
                          : AppTheme.mediumGray,
                    ),
                    const SizedBox(width: AppTheme.spaceMD),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: _isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: _isSelected
                              ? AppTheme.primaryBlack
                              : AppTheme.charcoal,
                        ),
                      ),
                    ),
                    if (widget.badgeCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlack,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.badgeCount}',
                          style: const TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
