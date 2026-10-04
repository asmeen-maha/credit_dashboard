import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import 'dashboard_card.dart';

class TablesAndDonutsSection extends StatelessWidget {
  const TablesAndDonutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── AR by Agent Table ──
          Expanded(
            flex: 5,
            child: DashboardCard(
              title: 'AR by Agent',
              badge: 'Top 5',
              child: _AgentTable(),
            ),
          ),
          const SizedBox(width: 16),
          // ── Collection Status Donut ──
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: 'Collection Status',
              badge: 'Overview',
              child: _CollectionDonut(),
            ),
          ),
          const SizedBox(width: 16),
          // ── AR Aging Donut ──
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: 'AR Aging Distribution',
              badge: 'Breakdown',
              child: _AgingDonut(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentTable extends StatelessWidget {
  final List<Map<String, dynamic>> _agents = const [
    {
      'name': 'Somchai T.',
      'total': '฿ 12.4M',
      'collected': '82%',
      'status': 'On Track'
    },
    {
      'name': 'Nattaya P.',
      'total': '฿ 10.8M',
      'collected': '76%',
      'status': 'At Risk'
    },
    {
      'name': 'Wichai S.',
      'total': '฿ 9.2M',
      'collected': '91%',
      'status': 'Excellent'
    },
    {
      'name': 'Panida K.',
      'total': '฿ 8.7M',
      'collected': '68%',
      'status': 'Behind'
    },
    {
      'name': 'Anucha R.',
      'total': '฿ 7.1M',
      'collected': '85%',
      'status': 'On Track'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: p.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Agent',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 2,
                  child: Text('Total AR',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 2,
                  child: Text('Collected',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 2,
                  child: Text('Status',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted),
                      textAlign: TextAlign.right)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ..._agents.map((agent) {
          final statusColor = _statusColor(agent['status'] as String);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: p.surface,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.blue500.withOpacity(0.1),
                          child: Text(
                            (agent['name'] as String)[0],
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blue500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(agent['name'] as String,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: p.text)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(agent['total'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.textStrong)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(agent['collected'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(agent['status'] as String,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  static Color _statusColor(String status) {
    switch (status) {
      case 'Excellent':
        return AppColors.emerald500;
      case 'On Track':
        return AppColors.blue500;
      case 'At Risk':
        return AppColors.amber500;
      case 'Behind':
        return AppColors.rose500;
      default:
        return AppColors.slate500;
    }
  }
}

class _CollectionDonut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: 62,
                      title: '',
                      color: AppColors.emerald500,
                      radius: 24,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: '',
                      color: AppColors.blue500,
                      radius: 22,
                    ),
                    PieChartSectionData(
                      value: 12,
                      title: '',
                      color: AppColors.amber500,
                      radius: 20,
                    ),
                    PieChartSectionData(
                      value: 6,
                      title: '',
                      color: AppColors.rose500,
                      radius: 18,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('82.4%',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: p.textStrong)),
                  Text('collected',
                      style:
                          GoogleFonts.inter(fontSize: 11, color: p.textSubtle)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _legendItem(p, AppColors.emerald500, 'Collected', '62%'),
        _legendItem(p, AppColors.blue500, 'In Progress', '20%'),
        _legendItem(p, AppColors.amber500, 'Pending', '12%'),
        _legendItem(p, AppColors.rose500, 'Overdue', '6%'),
      ],
    );
  }

  static Widget _legendItem(
      AppPalette p, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.inter(fontSize: 11, color: p.textMuted)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600, color: p.text)),
        ],
      ),
    );
  }
}

class _AgingDonut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: 77.1,
                      title: '',
                      color: AppColors.blue500,
                      radius: 24,
                    ),
                    PieChartSectionData(
                      value: 11.4,
                      title: '',
                      color: AppColors.amber500,
                      radius: 22,
                    ),
                    PieChartSectionData(
                      value: 5.0,
                      title: '',
                      color: const Color(0xFFF97316),
                      radius: 20,
                    ),
                    PieChartSectionData(
                      value: 6.5,
                      title: '',
                      color: AppColors.rose500,
                      radius: 18,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('฿ 68.5M',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: p.textStrong)),
                  Text('total AR',
                      style:
                          GoogleFonts.inter(fontSize: 11, color: p.textSubtle)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _legendItem(p, AppColors.blue500, '0-30 Days', '77.1%'),
        _legendItem(p, AppColors.amber500, '31-60 Days', '11.4%'),
        _legendItem(p, const Color(0xFFF97316), '61-90 Days', '5.0%'),
        _legendItem(p, AppColors.rose500, '> 90 Days', '6.5%'),
      ],
    );
  }

  static Widget _legendItem(
      AppPalette p, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.inter(fontSize: 11, color: p.textMuted)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600, color: p.text)),
        ],
      ),
    );
  }
}
