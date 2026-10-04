import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import 'dashboard_card.dart';

class BottomActionSection extends StatelessWidget {
  const BottomActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Key Actions & Reminders ──
          Expanded(
            flex: 5,
            child: DashboardCard(
              title: 'Key Actions & Reminders',
              badge: 'Today',
              child: _ActionsTable(),
            ),
          ),
          const SizedBox(width: 16),
          // ── KPI Summary ──
          Expanded(
            flex: 4,
            child: DashboardCard(
              title: 'KPI Summary',
              badge: 'Progress',
              child: _KpiProgressBars(),
            ),
          ),
          const SizedBox(width: 16),
          // ── Insights ──
          Expanded(
            flex: 3,
            child: _InsightsCard(),
          ),
        ],
      ),
    );
  }
}

class _ActionsTable extends StatelessWidget {
  final List<Map<String, dynamic>> _actions = const [
    {
      'action': 'Follow up overdue > 60 days',
      'assignee': 'Somchai T.',
      'due': 'Today',
      'priority': 'High',
    },
    {
      'action': 'Review credit limit requests',
      'assignee': 'Nattaya P.',
      'due': 'Today',
      'priority': 'Medium',
    },
    {
      'action': 'Agent commission reconciliation',
      'assignee': 'Wichai S.',
      'due': 'Tomorrow',
      'priority': 'High',
    },
    {
      'action': 'Send payment reminders batch',
      'assignee': 'Panida K.',
      'due': 'Today',
      'priority': 'Low',
    },
    {
      'action': 'Dispute resolution — Hotel A',
      'assignee': 'Anucha R.',
      'due': 'Oct 5',
      'priority': 'Medium',
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
                  flex: 4,
                  child: Text('Action',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 2,
                  child: Text('Assignee',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 1,
                  child: Text('Due',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted))),
              Expanded(
                  flex: 1,
                  child: Text('Priority',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: p.textMuted),
                      textAlign: TextAlign.right)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ..._actions.map((action) {
          final priorityColor = _priorityColor(action['priority'] as String);
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
                    flex: 4,
                    child: Text(action['action'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: p.text),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(action['assignee'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: p.textMuted)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(action['due'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: action['due'] == 'Today'
                                ? AppColors.rose500
                                : p.textBody)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(action['priority'] as String,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: priorityColor)),
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

  static Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.rose500;
      case 'Medium':
        return AppColors.amber500;
      case 'Low':
        return AppColors.emerald500;
      default:
        return AppColors.slate500;
    }
  }
}

class _KpiProgressBars extends StatelessWidget {
  final List<Map<String, dynamic>> _kpis = const [
    {
      'label': 'Collection Rate',
      'value': 82.4,
      'target': 90,
      'color': 0xFF3B82F6
    },
    {
      'label': 'On-time Payment',
      'value': 71.0,
      'target': 85,
      'color': 0xFF10B981
    },
    {
      'label': 'Dispute Resolution',
      'value': 88.5,
      'target': 95,
      'color': 0xFF8B5CF6
    },
    {
      'label': 'Customer Satisfaction',
      'value': 94.2,
      'target': 90,
      'color': 0xFF06B6D4
    },
    {
      'label': 'Agent Productivity',
      'value': 76.8,
      'target': 80,
      'color': 0xFFF59E0B
    },
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Column(
      children: _kpis.map((kpi) {
        final color = Color(kpi['color'] as int);
        final value = kpi['value'] as double;
        final target = kpi['target'] as int;
        final isAboveTarget = value >= target;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(kpi['label'] as String,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: p.textBody)),
                  Row(
                    children: [
                      Text('${value.toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: p.textStrong)),
                      Text(' / $target%',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: p.textSubtle)),
                      const SizedBox(width: 6),
                      Icon(
                        isAboveTarget
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color:
                            isAboveTarget ? AppColors.emerald500 : p.textFaint,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: p.track,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: (value / 100).clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.surface,
            AppColors.blue500.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: p.cardShadow,
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.violet500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    size: 16, color: AppColors.violet500),
              ),
              const SizedBox(width: 8),
              Text('Insights & Recommendations',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: p.textStrong)),
            ],
          ),
          const SizedBox(height: 16),
          _insightItem(
            p,
            Icons.trending_up_rounded,
            AppColors.rose500,
            'ยอดค้างชำระเกิน 30 วันเพิ่มขึ้น 2.8% — ควรเร่งติดตาม',
          ),
          const SizedBox(height: 10),
          _insightItem(
            p,
            Icons.bug_report_rounded,
            AppColors.amber500,
            'Package Mismatch เป็นปัญหาหลัก (23 cases) — ตรวจสอบ data entry',
          ),
          const SizedBox(height: 10),
          _insightItem(
            p,
            Icons.thumb_up_alt_rounded,
            AppColors.emerald500,
            'Collection Rate ดีขึ้นต่อเนื่อง 3 เดือน — keep it up!',
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: -0.08,
              child: Text(
                'Keep Going! 💪',
                style: GoogleFonts.caveat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue500.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _insightItem(
      AppPalette p, IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 12, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: GoogleFonts.inter(
                  fontSize: 12, height: 1.5, color: p.textBody)),
        ),
      ],
    );
  }
}
