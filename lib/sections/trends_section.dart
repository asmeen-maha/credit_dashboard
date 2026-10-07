import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/motion.dart';
import '../theme/neu.dart';
import '../widgets/dashboard_card.dart';

// =====================================================================
//  TRENDS & TARGETS — aging bars, collection trend, KPI progress
// =====================================================================

TextStyle _axisStyle(AppPalette p) => GoogleFonts.inter(
    fontSize: 11, color: p.textSubtle, fontWeight: FontWeight.w500);

/// Bars filling pressed-in tracks, value above and bucket below.
class ArAgingCard extends StatelessWidget {
  const ArAgingCard({super.key});

  static const double _max = 60;
  static const _buckets = [
    (label: '0-30', value: 52.78, color: AppColors.blue500),
    (label: '31-60', value: 7.84, color: AppColors.amber500),
    (label: '61-90', value: 3.39, color: AppColors.orange500),
    (label: '>90', value: 4.44, color: AppColors.rose500),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return DashboardCard(
      title: 'AR Aging Analysis',
      badge: 'This Month',
      child: Semantics(
        label: 'AR aging in million baht: '
            '${_buckets.map((b) => '${b.label} days ${b.value}').join(', ')}',
        child: ExcludeSemantics(
          // Bars rise one after another.
          child: PlayOnce(
            builder: (context, t, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final b in _buckets)
                  Column(
                    children: [
                      Text('${b.value}M',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: p.textStrong,
                              fontFeatures: tabularFigures)),
                      const SizedBox(height: 8),
                      NeuBox(
                        inset: true,
                        radius: 15,
                        distance: 4,
                        width: 30,
                        height: 160,
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: (b.value / _max).clamp(0.06, 1.0) *
                                stagger(
                                    t, _buckets.indexOf(b), _buckets.length),
                            child: Container(
                              decoration: BoxDecoration(
                                color: b.color,
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(b.label, style: _axisStyle(p)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Line chart shown on a pressed-in "screen". The line draws itself from
/// left to right: axes and grid sit in a still layer, the lines in a layer
/// above that is revealed once.
class CollectionTrendCard extends StatelessWidget {
  const CollectionTrendCard({super.key});

  static const _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
  static const _collected = [3.8, 4.2, 3.5, 5.1, 4.8, 5.6];
  static const double _target = 4.5;

  /// One chart configuration for both layers so they line up exactly;
  /// [lines] picks the layer: lines only, or axes and grid only.
  static LineChartData _data(AppPalette p, {required bool lines}) {
    final tooltipStyle = GoogleFonts.inter(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12);
    Widget title(Widget label) => lines ? const SizedBox.shrink() : label;
    return LineChartData(
      minX: 0,
      maxX: _collected.length - 1,
      minY: 0,
      maxY: 8,
      lineBarsData: !lines
          ? []
          : [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < _collected.length; i++)
                    FlSpot(i.toDouble(), _collected[i]),
                ],
                color: p.accent,
                barWidth: 3.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 5,
                    color: p.bg,
                    strokeWidth: 3,
                    strokeColor: p.accent,
                  ),
                ),
              ),
              LineChartBarData(
                spots: [
                  for (var i = 0; i < _collected.length; i++)
                    FlSpot(i.toDouble(), _target),
                ],
                color: AppColors.emerald500,
                barWidth: 2,
                dashArray: [6, 4],
                dotData: const FlDotData(show: false),
              ),
            ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 26,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final i = value.toInt();
              if (i < 0 || i >= _months.length) {
                return const SizedBox.shrink();
              }
              return title(Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_months[i], style: _axisStyle(p)),
              ));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 2,
            getTitlesWidget: (value, meta) =>
                title(Text('${value.toInt()}M', style: _axisStyle(p))),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: !lines,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: p.line, strokeWidth: 1, dashArray: [4, 4]),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        enabled: lines,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 10,
          getTooltipColor: (_) => p.tooltip,
          getTooltipItems: (spots) => [
            for (final s in spots)
              LineTooltipItem(
                s.barIndex == 0
                    ? 'Collected ฿ ${s.y.toStringAsFixed(1)}M'
                    : 'Target ฿ ${s.y.toStringAsFixed(1)}M',
                tooltipStyle,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return DashboardCard(
      title: 'Collection Trend',
      badge: '6 Months',
      child: Column(
        children: [
          NeuBox(
            inset: true,
            radius: 18,
            distance: 4,
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            child: Semantics(
              label: 'Monthly collection in million baht against a '
                  '$_target million target: '
                  '${[
                for (var i = 0; i < 6; i++) '${_months[i]} ${_collected[i]}'
              ].join(', ')}',
              child: SizedBox(
                height: 190,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LineChart(_data(p, lines: false)),
                    RepaintBoundary(
                      child: RevealLeftToRight(
                        child: LineChart(_data(p, lines: true)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legend(p, p.accent, 'Collected', dashed: false),
              const SizedBox(width: 20),
              _legend(p, AppColors.emerald500, 'Target ฿ 4.5M', dashed: true),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _legend(AppPalette p, Color color, String label,
      {required bool dashed}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dashed)
          for (var i = 0; i < 3; i++)
            Container(
              width: 4,
              height: 2.5,
              margin: const EdgeInsets.only(right: 2),
              color: color,
            )
        else
          Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
          ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: p.textMuted)),
      ],
    );
  }
}

/// Progress fills in pressed-in tracks, with a marker at the target.
class KpiSummaryCard extends StatelessWidget {
  const KpiSummaryCard({super.key});

  static const _kpis = [
    (
      label: 'Collection Rate',
      value: 82.4,
      target: 90,
      color: AppColors.blue500
    ),
    (
      label: 'On-time Payment',
      value: 71.0,
      target: 85,
      color: AppColors.emerald500
    ),
    (
      label: 'Dispute Resolution',
      value: 88.5,
      target: 95,
      color: AppColors.violet500
    ),
    (
      label: 'Customer Satisfaction',
      value: 94.2,
      target: 90,
      color: AppColors.cyan500
    ),
    (
      label: 'Agent Productivity',
      value: 76.8,
      target: 80,
      color: AppColors.amber500
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return DashboardCard(
      title: 'KPI Summary',
      badge: 'Progress',
      child: Column(
        children: [
          for (final kpi in _kpis) ...[
            Semantics(
              label: '${kpi.label}: ${kpi.value}% of ${kpi.target}% target, '
                  '${kpi.value >= kpi.target ? 'target met' : 'below target'}',
              child: ExcludeSemantics(
                // Bars fill one after another; a met target pops in last.
                child: PlayOnce(
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.linear,
                  builder: (context, t, _) => _bar(
                      p, kpi, stagger(t, _kpis.indexOf(kpi), _kpis.length)),
                ),
              ),
            ),
            if (kpi != _kpis.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  static Widget _bar(AppPalette p,
      ({String label, double value, int target, Color color}) kpi, double t) {
    final met = kpi.value >= kpi.target;
    final fill = Curves.easeOutCubic.transform((t / 0.7).clamp(0.0, 1.0));
    final pop = Curves.elasticOut.transform(((t - 0.6) / 0.4).clamp(0.0, 1.0));
    final status = Text(met ? '✓ met' : 'below',
        style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: met ? p.onAccent(AppColors.emerald500) : p.textSubtle));
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(kpi.label,
                  style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: p.textBody),
                  overflow: TextOverflow.ellipsis),
            ),
            Text('${kpi.value.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: p.textStrong,
                    fontFeatures: tabularFigures)),
            Text(' / ${kpi.target}%',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: p.textSubtle,
                    fontFeatures: tabularFigures)),
            const SizedBox(width: 6),
            met ? Transform.scale(scale: pop, child: status) : status,
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 18,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              NeuBox(
                inset: true,
                radius: 7,
                distance: 3,
                height: 14,
                padding: const EdgeInsets.all(3),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (kpi.value / 100).clamp(0.0, 1.0) * fill,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kpi.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              // Target marker.
              Align(
                alignment: Alignment(kpi.target / 50 - 1, 0),
                child: Container(
                  width: 2,
                  height: 18,
                  decoration: BoxDecoration(
                    color: p.textStrong.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
