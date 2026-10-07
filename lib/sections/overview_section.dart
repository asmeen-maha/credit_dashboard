import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/motion.dart';
import '../theme/neu.dart';
import '../widgets/dashboard_card.dart';

// =====================================================================
//  FINANCIAL OVERVIEW — hero Total AR + 2×2 KPI grid
// =====================================================================
class OverviewSection extends StatelessWidget {
  /// Hero and grid side by side; otherwise stacked.
  final bool wide;

  /// Phone width: KPI tiles in a single column instead of 2×2.
  final bool compact;

  const OverviewSection({super.key, required this.wide, this.compact = false});

  static const double _gap = 22;

  static const _kpis = [
    _Kpi(
      title: 'Current AR (0-30)',
      amount: 52.78,
      icon: Icons.check_circle_rounded,
      color: AppColors.emerald500,
      subtitle: '77.1% of total',
    ),
    _Kpi(
      title: 'Overdue (31-90)',
      amount: 11.23,
      icon: Icons.hourglass_bottom_rounded,
      color: AppColors.amber500,
      subtitle: '16.4% of total',
      trend: '↑ 2.8%',
      trendGood: false,
    ),
    _Kpi(
      title: 'Overdue > 90 Days',
      amount: 4.44,
      icon: Icons.warning_amber_rounded,
      color: AppColors.rose500,
      subtitle: '6.5% of total',
      trend: '↑ 1.2%',
      trendGood: false,
    ),
    _Kpi(
      title: 'Pay Advance Out',
      amount: 8.32,
      icon: Icons.schedule_rounded,
      color: AppColors.sky500,
      subtitle: '12.1% of total',
      trend: '↓ 5.6%',
      trendGood: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget gridRow(int i) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _KpiTile(_kpis[i])),
              const SizedBox(width: _gap),
              Expanded(child: _KpiTile(_kpis[i + 1])),
            ],
          ),
        );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HeroCard(),
          if (compact)
            for (final kpi in _kpis) ...[
              const SizedBox(height: _gap),
              _KpiTile(kpi),
            ]
          else ...[
            const SizedBox(height: _gap),
            gridRow(0),
            const SizedBox(height: _gap),
            gridRow(2),
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 5, child: _HeroCard()),
          const SizedBox(width: _gap),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Expanded(child: gridRow(0)),
                const SizedBox(height: _gap),
                Expanded(child: gridRow(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  static const _aging = [
    (label: 'Current 0-30', share: 77.1, color: AppColors.emerald500),
    (label: '31-90 days', share: 16.4, color: AppColors.amber500),
    (label: '> 90 days', share: 6.5, color: AppColors.rose500),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 28,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NeuIconWell(Icons.account_balance_rounded, p.accent, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Text('Total Accounts Receivable',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CountUpText(68.45,
              decimals: 2,
              prefix: '฿ ',
              suffix: 'M',
              style: GoogleFonts.inter(
                  fontSize: 46,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: p.textStrong,
                  fontFeatures: tabularFigures)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const NeuChip(label: '↓ 3.2%', color: AppColors.emerald500),
              Text('vs last month — lower AR is better',
                  style: GoogleFonts.inter(fontSize: 12, color: p.textSubtle)),
            ],
          ),
          const SizedBox(height: 24),
          // ── Aging composition in a pressed-in track ──
          Semantics(
            label: 'Aging composition: '
                '${_aging.map((a) => '${a.label} ${a.share}%').join(', ')}',
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeuBox(
                    inset: true,
                    radius: 10,
                    distance: 3,
                    height: 16,
                    padding: const EdgeInsets.all(3),
                    // Segments sweep in from the left.
                    child: RevealLeftToRight(
                      child: Row(
                        children: [
                          for (final a in _aging)
                            Expanded(
                              flex: (a.share * 10).round(),
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: a == _aging.last ? 0 : 3),
                                decoration: BoxDecoration(
                                  color: a.color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      for (final a in _aging)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: a.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(a.label,
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: p.textMuted)),
                            const SizedBox(width: 4),
                            Text('${a.share}%',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: p.textStrong,
                                    fontFeatures: tabularFigures)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Kpi {
  final String title;

  /// Million baht.
  final double amount;
  final IconData icon;
  final Color color;
  final String subtitle;
  final String? trend;
  final bool trendGood;

  const _Kpi({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.subtitle,
    this.trend,
    this.trendGood = true,
  });
}

class _KpiTile extends StatelessWidget {
  final _Kpi kpi;

  const _KpiTile(this.kpi);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NeuIconWell(kpi.icon, kpi.color, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Text(kpi.title,
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: p.textMuted),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 14),
          CountUpText(kpi.amount,
              decimals: 2,
              prefix: '฿ ',
              suffix: 'M',
              style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: p.textStrong,
                  fontFeatures: tabularFigures)),
          const SizedBox(height: 6),
          Text(kpi.subtitle,
              style: GoogleFonts.inter(fontSize: 12, color: p.textSubtle)),
          if (kpi.trend != null) ...[
            const SizedBox(height: 10),
            NeuChip(
              label: '${kpi.trend!} vs last month',
              color: kpi.trendGood ? AppColors.emerald500 : AppColors.rose500,
            ),
          ],
        ],
      ),
    );
  }
}

// =====================================================================
//  TODAY'S OPERATIONS — raised tiles in a pressed-in well
// =====================================================================
class OperationsStrip extends StatelessWidget {
  final int columns;

  const OperationsStrip({super.key, required this.columns});

  static const double _gap = 14;

  static const _items = [
    (
      label: 'Invoices Today',
      n: 142.0,
      dp: 0,
      pre: '',
      suf: '',
      color: AppColors.cyan500
    ),
    (
      label: 'Collected',
      n: 4.2,
      dp: 1,
      pre: '฿ ',
      suf: 'M',
      color: AppColors.emerald500
    ),
    (
      label: 'Collection Rate',
      n: 82.4,
      dp: 1,
      pre: '',
      suf: '%',
      color: AppColors.indigo500
    ),
    (
      label: 'Follow-ups Done',
      n: 67.0,
      dp: 0,
      pre: '',
      suf: ' / 85',
      color: AppColors.amber500
    ),
    (
      label: 'Disputes Open',
      n: 12.0,
      dp: 0,
      pre: '',
      suf: '',
      color: AppColors.rose500
    ),
    (
      label: 'DSO (Days)',
      n: 38.0,
      dp: 0,
      pre: '',
      suf: '',
      color: AppColors.teal500
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      inset: true,
      radius: 26,
      distance: 7,
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - _gap * (columns - 1)) / columns;
          return Wrap(
            spacing: _gap,
            runSpacing: _gap,
            children: [
              for (final item in _items)
                SizedBox(
                  width: width,
                  child: Semantics(
                    label: '${item.label}: '
                        '${item.pre}${item.n.toStringAsFixed(item.dp)}${item.suf}',
                    child: ExcludeSemantics(
                      child: NeuBox(
                        radius: 18,
                        distance: 5,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 34,
                              decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.label,
                                      style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: p.textMuted,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  CountUpText(item.n,
                                      decimals: item.dp,
                                      prefix: item.pre,
                                      suffix: item.suf,
                                      style: GoogleFonts.inter(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          color: p.textStrong,
                                          fontFeatures: tabularFigures)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
