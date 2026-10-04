import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import 'dashboard_card.dart';

class ChartsAndIssuesSection extends StatelessWidget {
  const ChartsAndIssuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── AR Aging Bar Chart ──
        Expanded(
          flex: 3,
          child: DashboardCard(
            title: 'AR Aging Analysis',
            badge: 'This Month',
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    _agingBar(
                        0, 52.78, [AppColors.blue500, const Color(0xFF6366F1)]),
                    _agingBar(
                        1, 7.84, [AppColors.amber500, AppColors.amber600]),
                    _agingBar(
                        2, 3.39, [const Color(0xFFF97316), AppColors.rose500]),
                    _agingBar(3, 4.44, [AppColors.rose500, AppColors.rose600]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          const titles = ['0-30', '31-60', '61-90', '>90'];
                          if (value.toInt() >= 0 &&
                              value.toInt() < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(titles[value.toInt()],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: p.textSubtle,
                                      fontWeight: FontWeight.w500)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 15,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}M',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: p.textSubtle));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 15,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: p.gridLine,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '฿ ${rod.toY.toStringAsFixed(2)}M',
                          GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        );
                      },
                    ),
                  ),
                  maxY: 60,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // ── Collection Trend ──
        Expanded(
          flex: 5,
          child: DashboardCard(
            title: 'Collection Trend',
            badge: '6 Months',
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    // Collection amount line
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3.8),
                        FlSpot(1, 4.2),
                        FlSpot(2, 3.5),
                        FlSpot(3, 5.1),
                        FlSpot(4, 4.8),
                        FlSpot(5, 5.6),
                      ],
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppColors.blue500,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: p.surface,
                          strokeWidth: 2.5,
                          strokeColor: AppColors.blue500,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.blue500.withOpacity(0.15),
                            AppColors.blue500.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    // Target line
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 4.5),
                        FlSpot(1, 4.5),
                        FlSpot(2, 4.5),
                        FlSpot(3, 4.5),
                        FlSpot(4, 4.5),
                        FlSpot(5, 4.5),
                      ],
                      isCurved: false,
                      color: AppColors.emerald500.withOpacity(0.5),
                      barWidth: 2,
                      dashArray: [6, 4],
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep'
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(months[value.toInt()],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: p.textSubtle,
                                      fontWeight: FontWeight.w500)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}M',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: p.textSubtle));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: p.gridLine,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 8,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '฿ ${spot.y.toStringAsFixed(1)}M',
                            GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // ── Top 5 Issues ──
        Expanded(
          flex: 4,
          child: DashboardCard(
            title: 'Top 3 Issues Today',
            badge: 'Critical',
            badgeColor: AppColors.rose500,
            child: _TopIssuesList(),
          ),
        ),
      ],
    );
  }

  static BarChartGroupData _agingBar(int x, double y, List<Color> colors) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: colors,
          ),
          width: 28,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}

class _TopIssuesList extends StatelessWidget {
  final List<Map<String, dynamic>> _issues = const [
    {
      'title': 'Package Mismatch',
      'desc': 'ข้อมูลแพ็กเกจไม่ตรงกับระบบ',
      'count': 23,
      'color': 0xFFF43F5E,
    },
    {
      'title': 'Payment Delay > 60d',
      'desc': 'ลูกค้าค้างชำระเกิน 60 วัน',
      'count': 18,
      'color': 0xFFF59E0B,
    },
    {
      'title': 'Duplicate Invoice',
      'desc': 'ใบแจ้งหนี้ซ้ำในระบบ',
      'count': 12,
      'color': 0xFF8B5CF6,
    },
    /*{
      'title': 'Credit Limit Exceed',
      'desc': 'วงเงินเครดิตเกินกำหนด',
      'count': 9,
      'color': 0xFF3B82F6,
    },
     {
      'title': 'Agent Commission Error',
      'desc': 'ค่าคอมมิชชั่นคำนวณผิดพลาด',
      'count': 7,
      'color': 0xFF06B6D4,
    } */
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    // Match the 200px chart height of the sibling cards.
    return SizedBox(
      height: 200,
      child: Column(
        children: _issues.asMap().entries.map((entry) {
          final i = entry.key;
          final issue = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: i < _issues.length - 1 ? 8 : 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: p.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: p.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color(issue['color'] as int).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text('${i + 1}',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(issue['color'] as int))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(issue['title'] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: p.text)),
                          Text(issue['desc'] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: p.textSubtle),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(issue['color'] as int).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${issue['count']}',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(issue['color'] as int))),
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
