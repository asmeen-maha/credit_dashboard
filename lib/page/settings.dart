import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/neu.dart';
import '../theme/theme_controller.dart';

// =====================================================================
//  SETTINGS PAGE
// =====================================================================
class SettingsPage extends StatelessWidget {
  final EdgeInsets padding;

  const SettingsPage({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingsGroup(
                title: 'Appearance',
                subtitle: 'Choose how the dashboard looks.',
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance,
                  builder: (context, mode, _) => LayoutBuilder(
                    builder: (context, constraints) {
                      final tiles = [
                        for (final option in _themeOptions)
                          _ThemeOptionTile(
                            icon: option.icon,
                            label: option.label,
                            description: option.description,
                            selected: mode == option.mode,
                            onTap: () =>
                                ThemeController.instance.setMode(option.mode),
                          ),
                      ];
                      if (constraints.maxWidth < 520) {
                        return Column(
                          children: [
                            for (final t in tiles) ...[
                              if (t != tiles.first) const SizedBox(height: 14),
                              t,
                            ],
                          ],
                        );
                      }
                      return Row(
                        children: [
                          for (final t in tiles) ...[
                            if (t != tiles.first) const SizedBox(width: 16),
                            Expanded(child: t),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SettingsGroup(
                title: 'Accessibility',
                subtitle: 'Make the soft surfaces easier to tell apart.',
                child: ValueListenableBuilder<bool>(
                  valueListenable: ContrastController.instance,
                  builder: (context, increased, _) => _SwitchRow(
                    icon: Icons.contrast_rounded,
                    label: 'Increase contrast',
                    description:
                        'Outline every surface and deepen its shadows.',
                    value: increased,
                    onChanged: ContrastController.instance.setIncreased,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsGroup({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 26,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title,
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: p.textStrong)),
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: GoogleFonts.inter(fontSize: 13, color: p.textMuted)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

const List<({ThemeMode mode, IconData icon, String label, String description})>
    _themeOptions = [
  (
    mode: ThemeMode.system,
    icon: Icons.brightness_auto_rounded,
    label: 'System',
    description: 'Follow device setting',
  ),
  (
    mode: ThemeMode.light,
    icon: Icons.light_mode_rounded,
    label: 'Light',
    description: 'Always light',
  ),
  (
    mode: ThemeMode.dark,
    icon: Icons.dark_mode_rounded,
    label: 'Dark',
    description: 'Always dark',
  ),
];

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: NeuButton(
        onTap: onTap,
        selected: selected,
        radius: 18,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            NeuIconWell(icon, selected ? p.accent : AppColors.slate500,
                size: 34),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: selected ? p.accent : p.textStrong)),
                  const SizedBox(height: 2),
                  Text(description,
                      style:
                          GoogleFonts.inter(fontSize: 12, color: p.textSubtle),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 18, color: p.accent),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return MergeSemantics(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(14),
          hoverColor: p.line,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                NeuIconWell(icon, AppColors.slate500, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: p.textStrong)),
                      const SizedBox(height: 2),
                      Text(description,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: p.textSubtle)),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: p.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
