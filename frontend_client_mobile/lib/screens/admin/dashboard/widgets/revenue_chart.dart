import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';

class RevenueChart extends StatelessWidget {
  final List<int> data;
  const RevenueChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppTheme.primaryBlack,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[value.toInt()],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: AppTheme.veryLightGray, strokeWidth: 1);
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            data.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].toDouble(),
                  color: AppTheme.primaryBlack,
                  width: 24,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 20, // Max value assumption
                    color: AppTheme.offWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
