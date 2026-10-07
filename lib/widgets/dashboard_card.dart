import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/neu.dart';

/// Raised neumorphic card with a title row and optional status badge.
class DashboardCard extends StatelessWidget {
  final String title;
  final String? badge;
  final Color? badgeColor;
  final Widget child;

  const DashboardCard({
    super.key,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 26,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: p.textStrong),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              if (badge != null)
                NeuChip(
                  label: badge!,
                  color: badgeColor ?? AppColors.blue500,
                  dot: badgeColor != null,
                ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

/// Lays children out side by side (with equal heights) when [wide],
/// stacked full-width otherwise.
class AdaptiveRow extends StatelessWidget {
  final bool wide;
  final List<(int, Widget)> children;
  final double spacing;

  const AdaptiveRow({
    super.key,
    required this.wide,
    required this.children,
    this.spacing = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i].$2,
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(flex: children[i].$1, child: children[i].$2),
          ],
        ],
      ),
    );
  }
}

/// Heading that introduces a group of cards on the dashboard.
class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title,
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: p.textStrong)),
          ),
          const SizedBox(height: 2),
          Text(subtitle,
              style: GoogleFonts.inter(fontSize: 12.5, color: p.textMuted)),
        ],
      ),
    );
  }
}

/// Tabular figures keep numbers aligned in tables and KPI tiles.
const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];
