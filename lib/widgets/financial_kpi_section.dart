import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class FinancialKpiSection extends StatelessWidget {
  const FinancialKpiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: _FinancialCard(
                title: 'Total AR',
                value: '฿ 68.45M',
                icon: Icons.account_balance_rounded,
                gradientColors: [AppColors.blue500, Color(0xFF6366F1)],
                trendText: '↓ 3.2%',
                isPositive: true)),
        SizedBox(width: 16),
        Expanded(
            child: _FinancialCard(
                title: 'Current AR (0-30)',
                value: '฿ 52.78M',
                icon: Icons.check_circle_rounded,
                gradientColors: [AppColors.emerald500, Color(0xFF14B8A6)],
                subtitle: '77.1% of Total')),
        SizedBox(width: 16),
        Expanded(
            child: _FinancialCard(
                title: 'Overdue (31-90)',
                value: '฿ 11.23M',
                icon: Icons.hourglass_empty_rounded,
                gradientColors: [AppColors.rose500, Color(0xFFEC4899)],
                subtitle: '16.4% of Total',
                trendText: '↑ 2.8%',
                isPositive: false)),
        SizedBox(width: 16),
        Expanded(
            child: _FinancialCard(
                title: 'Overdue > 90 Days',
                value: '฿ 4.44M',
                icon: Icons.warning_amber_rounded,
                gradientColors: [AppColors.amber500, Color(0xFFEF4444)],
                subtitle: '6.5% of Total',
                trendText: '↑ 1.2%',
                isPositive: false)),
        SizedBox(width: 16),
        Expanded(
            child: _FinancialCard(
                title: 'Pay Advance Out',
                value: '฿ 8.32M',
                icon: Icons.schedule_rounded,
                gradientColors: [Color(0xFF06B6D4), AppColors.blue500],
                subtitle: '12.1% of Total',
                trendText: '↓ 5.6%',
                isPositive: true)),
      ],
    );
  }
}

class _FinancialCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;
  final String? subtitle;
  final String? trendText;
  final bool? isPositive;

  const _FinancialCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradientColors,
    this.subtitle,
    this.trendText,
    this.isPositive,
  });

  @override
  State<_FinancialCard> createState() => _FinancialCardState();
}

class _FinancialCardState extends State<_FinancialCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: _hovering
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovering ? p.elevatedShadow : p.cardShadow,
          border: Border.all(
            color: _hovering
                ? widget.gradientColors.first.withOpacity(0.2)
                : p.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.gradientColors.first.withOpacity(0.15),
                        widget.gradientColors.last.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon,
                      size: 18, color: widget.gradientColors.first),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.title,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: p.textMuted),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.value,
                style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: p.textStrong)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.subtitle != null)
                  Text(widget.subtitle!,
                      style:
                          GoogleFonts.inter(fontSize: 11, color: p.textSubtle)),
                if (widget.trendText != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.isPositive == true
                          ? AppColors.emerald500.withOpacity(0.1)
                          : AppColors.rose500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(widget.trendText!,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.isPositive == true
                                ? AppColors.emerald600
                                : AppColors.rose600)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
