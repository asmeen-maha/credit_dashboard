import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/motion.dart';
import '../theme/neu.dart';
import '../theme/theme_controller.dart';

/// Raised header slab that stays at the top while content scrolls under
/// it. [onMenu] shows a menu button (small screens).
class TopHeaderWidget extends StatelessWidget {
  static const double height = 76;

  final String title;
  final VoidCallback? onMenu;
  final bool compact;

  const TopHeaderWidget({
    super.key,
    required this.title,
    this.onMenu,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 24,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 22),
      height: height,
      child: Row(
        children: [
          if (onMenu != null) ...[
            NeuButton(
              tooltip: 'Open navigation',
              semanticLabel: 'Open navigation',
              width: 44,
              height: 44,
              radius: 14,
              onTap: onMenu,
              child: Center(
                child: Icon(Icons.menu_rounded, color: p.textStrong, size: 20),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: compact ? 18 : 21,
                          fontWeight: FontWeight.w800,
                          color: p.textStrong)),
                ),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      _HeaderTag('Better Data', AppColors.blue500),
                      SizedBox(width: 14),
                      _HeaderTag('Faster Process', AppColors.emerald500),
                      SizedBox(width: 14),
                      _HeaderTag('Healthier Cash Flow', AppColors.violet500),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!compact) ...[
            const _ClockChip(),
            const SizedBox(width: 16),
          ],
          const _ThemeToggle(),
          const SizedBox(width: 16),
          _profile(p),
        ],
      ),
    );
  }

  Widget _profile(AppPalette p) {
    return Semantics(
      label: 'Signed in as AR Manager, Credit & Collection',
      child: ExcludeSemantics(
        child: Row(
          children: [
            NeuBox(
              radius: 22,
              distance: 5,
              width: 44,
              height: 44,
              child: Icon(Icons.person_rounded, color: p.accent, size: 22),
            ),
            if (!compact) ...[
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AR Manager',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: p.textStrong)),
                  Text('Credit & Collection',
                      style:
                          GoogleFonts.inter(fontSize: 11, color: p.textSubtle)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Header slogan: colored dot and text, no surface of its own.
class _HeaderTag extends StatelessWidget {
  final String text;
  final Color color;

  const _HeaderTag(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Flexible(
      child: Text('● $text',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: p.onAccent(color))),
    );
  }
}

/// Live date and time in a pressed-in well, refreshed every 20 seconds.
class _ClockChip extends StatefulWidget {
  const _ClockChip();

  @override
  State<_ClockChip> createState() => _ClockChipState();
}

class _ClockChipState extends State<_ClockChip> {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  DateTime _now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final date =
        '${_weekdays[_now.weekday - 1]}, ${_now.day} ${_months[_now.month - 1]} ${_now.year}';
    final time =
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    return NeuBox(
      inset: true,
      radius: 14,
      distance: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 14, color: p.textMuted),
          const SizedBox(width: 8),
          Text(date,
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: p.text)),
          Text('  ·  $time',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: p.textMuted,
                  fontFeatures: const [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}

/// Round light/dark switch: pressed in while dark mode is on.
/// Settings keeps the "System" option.
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuButton(
      tooltip: p.isDark ? 'Switch to light mode' : 'Switch to dark mode',
      semanticLabel: 'Dark mode',
      selected: p.isDark,
      width: 48,
      height: 48,
      radius: 24,
      onTap: () => ThemeController.instance
          .setMode(p.isDark ? ThemeMode.light : ThemeMode.dark),
      // Sun and moon swap with a quarter turn.
      child: Center(
        child: AnimatedSwitcher(
          duration: Motion.of(context, Motion.theme),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: Tween(begin: -0.25, end: 0.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Icon(
            p.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(p.isDark),
            size: 20,
            color: p.isDark ? p.accent : p.textMuted,
          ),
        ),
      ),
    );
  }
}
