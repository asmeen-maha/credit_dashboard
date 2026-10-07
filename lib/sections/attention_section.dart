import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/neu.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/neu_table.dart';

// =====================================================================
//  NEEDS ATTENTION TODAY — issues, actions, insights
// =====================================================================

class TopIssuesCard extends StatelessWidget {
  const TopIssuesCard({super.key});

  static const _issues = [
    (
      title: 'Package Mismatch',
      desc: 'ข้อมูลแพ็กเกจไม่ตรงกับระบบ',
      count: 23,
      color: AppColors.rose500,
    ),
    (
      title: 'Payment Delay > 60d',
      desc: 'ลูกค้าค้างชำระเกิน 60 วัน',
      count: 18,
      color: AppColors.amber500,
    ),
    (
      title: 'Duplicate Invoice',
      desc: 'ใบแจ้งหนี้ซ้ำในระบบ',
      count: 12,
      color: AppColors.violet500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return DashboardCard(
      title: 'Top 3 Issues Today',
      badge: 'Critical',
      badgeColor: AppColors.rose500,
      child: Column(
        children: [
          for (var i = 0; i < _issues.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _IssueRow(
              rank: i + 1,
              title: _issues[i].title,
              desc: _issues[i].desc,
              count: _issues[i].count,
              color: _issues[i].color,
              onTap: () => showNeuDialog(
                context: context,
                heroTag: _IssueRow.heroTag(i + 1),
                title: _issues[i].title,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_issues[i].desc,
                        style: GoogleFonts.inter(
                            fontSize: 14, height: 1.5, color: p.textBody)),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        NeuChip(
                            label: 'Rank #${i + 1}',
                            color: _issues[i].color,
                            dot: true),
                        NeuChip(
                            label: '${_issues[i].count} open cases',
                            color: AppColors.blue500),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  final int rank;
  final String title;
  final String desc;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _IssueRow({
    required this.rank,
    required this.title,
    required this.desc,
    required this.count,
    required this.color,
    required this.onTap,
  });

  /// Shared with the detail dialog, which grows out of this row.
  static String heroTag(int rank) => 'issue-$rank';

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final fg = p.onAccent(color);
    return NeuHero(tag: heroTag(rank), child: _button(p, fg));
  }

  Widget _button(AppPalette p, Color fg) {
    return NeuButton(
      onTap: onTap,
      radius: 18,
      semanticLabel: 'Issue $rank: $title, $count cases. $desc',
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: ExcludeSemantics(
        child: Row(
          children: [
            NeuBox(
              inset: true,
              radius: 11,
              distance: 4,
              width: 32,
              height: 32,
              child: Center(
                child: Text('$rank',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w800, color: fg)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: p.textStrong),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(desc,
                      style:
                          GoogleFonts.inter(fontSize: 12, color: p.textSubtle),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('$count',
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontFeatures: tabularFigures)),
          ],
        ),
      ),
    );
  }
}

class KeyActionsCard extends StatelessWidget {
  /// Narrow screens: hides the Assignee column.
  final bool compact;

  const KeyActionsCard({super.key, this.compact = false});

  static const _actions = [
    (
      action: 'Follow up overdue > 60 days',
      assignee: 'Somchai T.',
      due: 'Today',
      priority: 'High',
    ),
    (
      action: 'Review credit limit requests',
      assignee: 'Nattaya P.',
      due: 'Today',
      priority: 'Medium',
    ),
    (
      action: 'Agent commission reconciliation',
      assignee: 'Wichai S.',
      due: 'Tomorrow',
      priority: 'High',
    ),
    (
      action: 'Send payment reminders batch',
      assignee: 'Panida K.',
      due: 'Today',
      priority: 'Low',
    ),
    (
      action: 'Dispute resolution — Hotel A',
      assignee: 'Anucha R.',
      due: 'Oct 5',
      priority: 'Medium',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final head = NeuTable.headStyle(p);
    return DashboardCard(
      title: 'Key Actions & Reminders',
      badge: 'Today',
      child: NeuTable(
        header: [
          Expanded(flex: 4, child: Text('ACTION', style: head)),
          if (!compact) Expanded(flex: 2, child: Text('ASSIGNEE', style: head)),
          Expanded(flex: 2, child: Text('DUE', style: head)),
          Expanded(
              flex: 2,
              child: Text('PRIORITY', style: head, textAlign: TextAlign.right)),
        ],
        rows: [
          for (final a in _actions)
            [
              Expanded(
                flex: 4,
                child: Text(a.action,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: p.text)),
              ),
              if (!compact)
                Expanded(
                  flex: 2,
                  child: Text(a.assignee,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 12.5, color: p.textMuted)),
                ),
              Expanded(
                flex: 2,
                child: Text(a.due,
                    style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: a.due == 'Today'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: a.due == 'Today'
                            ? p.onAccent(AppColors.rose500)
                            : p.textBody)),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: NeuChip(
                      label: a.priority,
                      color: _priorityColor(a.priority),
                      dot: true),
                ),
              ),
            ],
        ],
      ),
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

class InsightsCard extends StatelessWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return DashboardCard(
      title: 'Insights & Recommendations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _insight(p, Icons.trending_up_rounded, AppColors.rose500,
              'ยอดค้างชำระเกิน 30 วันเพิ่มขึ้น 2.8% — ควรเร่งติดตาม'),
          const SizedBox(height: 16),
          _insight(p, Icons.priority_high_rounded, AppColors.amber500,
              'Package Mismatch เป็นปัญหาหลัก (23 cases) — ตรวจสอบ data entry'),
          const SizedBox(height: 16),
          _insight(p, Icons.check_rounded, AppColors.emerald500,
              'Collection Rate ดีขึ้นต่อเนื่อง 3 เดือน — keep it up!'),
        ],
      ),
    );
  }

  static Widget _insight(
      AppPalette p, IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeuIconWell(icon, color, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: GoogleFonts.inter(
                  fontSize: 13, height: 1.5, color: p.textBody)),
        ),
      ],
    );
  }
}
