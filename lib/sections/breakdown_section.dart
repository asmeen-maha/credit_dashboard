import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/motion.dart';
import '../theme/neu.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/neu_table.dart';

// =====================================================================
//  BREAKDOWN — AR by agent, collection status, aging distribution
// =====================================================================

class AgentTableCard extends StatelessWidget {
  /// Narrow screens: drops the Collected progress bar.
  final bool compact;

  const AgentTableCard({super.key, this.compact = false});

  static const _agents = [
    (name: 'Somchai T.', total: '฿ 12.4M', collected: 82, status: 'On Track'),
    (name: 'Nattaya P.', total: '฿ 10.8M', collected: 76, status: 'At Risk'),
    (name: 'Wichai S.', total: '฿ 9.2M', collected: 91, status: 'Excellent'),
    (name: 'Panida K.', total: '฿ 8.7M', collected: 68, status: 'Behind'),
    (name: 'Anucha R.', total: '฿ 7.1M', collected: 85, status: 'On Track'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final head = NeuTable.headStyle(p);
    if (compact) {
      // Phone width: one line per agent, figures under the name.
      return DashboardCard(
        title: 'AR by Agent',
        badge: 'Top 5',
        child: NeuTable(
          header: [
            Expanded(child: Text('AGENT', style: head)),
            Text('STATUS', style: head),
          ],
          rows: [for (final a in _agents) _compactCells(p, a)],
        ),
      );
    }
    return DashboardCard(
      title: 'AR by Agent',
      badge: 'Top 5',
      child: NeuTable(
        header: [
          Expanded(flex: 3, child: Text('AGENT', style: head)),
          Expanded(
              flex: 2,
              child: Text('TOTAL AR', style: head, textAlign: TextAlign.right)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: Text('COLLECTED', style: head)),
          Expanded(
              flex: 2,
              child: Text('STATUS', style: head, textAlign: TextAlign.right)),
        ],
        rows: [for (final a in _agents) _cells(p, a)],
      ),
    );
  }

  List<Widget> _compactCells(AppPalette p,
      ({String name, String total, int collected, String status}) a) {
    return [
      _avatar(p, a.name),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: p.textStrong)),
            Text('${a.total} · ${a.collected}% collected',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: p.textMuted,
                    fontFeatures: tabularFigures)),
          ],
        ),
      ),
      const SizedBox(width: 8),
      NeuChip(label: a.status, color: _statusColor(a.status), dot: true),
    ];
  }

  static Widget _avatar(AppPalette p, String name) {
    return NeuBox(
      radius: 15,
      distance: 3,
      width: 30,
      height: 30,
      child: Center(
        child: Text(name[0],
            style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: p.accent)),
      ),
    );
  }

  List<Widget> _cells(AppPalette p,
      ({String name, String total, int collected, String status}) a) {
    final statusColor = _statusColor(a.status);
    return [
      Expanded(
        flex: 3,
        child: Row(
          children: [
            _avatar(p, a.name),
            const SizedBox(width: 10),
            Flexible(
              child: Text(a.name,
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w500, color: p.text),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(a.total,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: p.textStrong,
                fontFeatures: tabularFigures)),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 3,
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text('${a.collected}%',
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: p.text,
                      fontFeatures: tabularFigures)),
            ),
            if (!compact)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: a.collected / 100,
                    minHeight: 6,
                    backgroundColor: p.trackFlat,
                    color: statusColor,
                  ),
                ),
              ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Align(
          alignment: Alignment.centerRight,
          child: NeuChip(label: a.status, color: statusColor, dot: true),
        ),
      ),
    ];
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

typedef _Slice = ({String label, double value, Color color});

class CollectionStatusCard extends StatelessWidget {
  const CollectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      title: 'Collection Status',
      badge: 'Overview',
      child: _Donut(
        centerNumber: 82.4,
        centerSuffix: '%',
        centerLabel: 'collected',
        slices: [
          (label: 'Collected', value: 62, color: AppColors.emerald500),
          (label: 'In Progress', value: 20, color: AppColors.blue500),
          (label: 'Pending', value: 12, color: AppColors.amber500),
          (label: 'Overdue', value: 6, color: AppColors.rose500),
        ],
      ),
    );
  }
}

class AgingDistributionCard extends StatelessWidget {
  const AgingDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      title: 'AR Aging Distribution',
      badge: 'Breakdown',
      child: _Donut(
        centerNumber: 68.5,
        centerPrefix: '฿ ',
        centerSuffix: 'M',
        centerLabel: 'total AR',
        slices: [
          (label: '0-30 Days', value: 77.1, color: AppColors.blue500),
          (label: '31-60 Days', value: 11.4, color: AppColors.amber500),
          (label: '61-90 Days', value: 5.0, color: AppColors.orange500),
          (label: '> 90 Days', value: 6.5, color: AppColors.rose500),
        ],
      ),
    );
  }
}

/// Colored ring in a pressed-in groove, with a raised button in the middle.
class _Donut extends StatelessWidget {
  final double centerNumber;
  final String centerPrefix;
  final String centerSuffix;
  final String centerLabel;
  final List<_Slice> slices;

  const _Donut({
    required this.centerNumber,
    this.centerPrefix = '',
    this.centerSuffix = '',
    required this.centerLabel,
    required this.slices,
  });

  static const double _size = 170;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    String pct(double v) => v == v.roundToDouble() ? '${v.toInt()}%' : '$v%';
    final centerValue = '$centerPrefix$centerNumber$centerSuffix';
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);
    return Semantics(
      label: '$centerValue $centerLabel. '
          '${slices.map((s) => '${s.label} ${pct(s.value)}').join(', ')}',
      child: ExcludeSemantics(
        child: Column(
          children: [
            NeuBox(
              inset: true,
              radius: _size / 2,
              distance: 7,
              width: _size,
              height: _size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The ring sweeps in clockwise from the top: each slice
                  // grows with progress and a transparent filler takes the
                  // rest of the circle until it is complete.
                  RepaintBoundary(
                    child: PlayOnce(
                      curve: Curves.easeInOutCubic,
                      builder: (context, t, _) => PieChart(
                        duration: Duration.zero,
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 47,
                          startDegreeOffset: -90,
                          sections: [
                            for (final s in slices)
                              if (s.value * t > 0)
                                PieChartSectionData(
                                  value: s.value * t,
                                  title: '',
                                  radius: 28,
                                  color: s.color,
                                ),
                            if (t < 1)
                              PieChartSectionData(
                                value: total * (1 - t),
                                title: '',
                                radius: 28,
                                color: Colors.transparent,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  NeuBox(
                    radius: 51,
                    distance: 5,
                    width: 102,
                    height: 102,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountUpText(centerNumber,
                            decimals: 1,
                            prefix: centerPrefix,
                            suffix: centerSuffix,
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: p.textStrong,
                                fontFeatures: tabularFigures)),
                        Text(centerLabel,
                            style: GoogleFonts.inter(
                                fontSize: 11.5, color: p.textSubtle)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            for (final s in slices)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(s.label,
                          style: GoogleFonts.inter(
                              fontSize: 12.5, color: p.textMuted),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(pct(s.value),
                        style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: p.textStrong,
                            fontFeatures: tabularFigures)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
