import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class StatsGrid extends StatelessWidget {
  final List<DashboardStat> stats;
  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppTheme.spaceMD,
        crossAxisSpacing: AppTheme.spaceMD,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];
        return Container(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: AppTheme.borderRadiusMD,
            border: AppTheme.borderThin,
            boxShadow: AppTheme.shadowSM,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.offWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                ),
                child: Icon(item.icon, color: AppTheme.primaryBlack, size: 20),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mediumGray,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: AppTheme.h4.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
