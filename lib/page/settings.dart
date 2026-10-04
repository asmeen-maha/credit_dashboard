import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/theme_controller.dart';

// =====================================================================
//  SETTINGS PAGE
// =====================================================================
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: p.cardShadow,
              border: Border.all(color: p.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appearance',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: p.textStrong)),
                const SizedBox(height: 4),
                Text('Choose how the dashboard looks.',
                    style: GoogleFonts.inter(fontSize: 12, color: p.textMuted)),
                const SizedBox(height: 16),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance,
                  builder: (context, mode, _) => Row(
                    children: [
                      for (final option in _themeOptions) ...[
                        if (option != _themeOptions.first)
                          const SizedBox(width: 12),
                        Expanded(
                          child: _ThemeOptionTile(
                            icon: option.icon,
                            label: option.label,
                            description: option.description,
                            selected: mode == option.mode,
                            onTap: () =>
                                ThemeController.instance.setMode(option.mode),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

class _ThemeOptionTile extends StatefulWidget {
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
  State<_ThemeOptionTile> createState() => _ThemeOptionTileState();
}

class _ThemeOptionTileState extends State<_ThemeOptionTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final selected = widget.selected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.cyan500.withOpacity(0.08)
                : _hovering
                    ? p.surfaceMuted
                    : p.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.cyan500 : p.gridLine,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (selected ? AppColors.cyan500 : p.textSubtle)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon,
                    size: 18,
                    color: selected ? AppColors.cyan500 : p.textMuted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: p.textStrong)),
                    const SizedBox(height: 2),
                    Text(widget.description,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: p.textSubtle),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    size: 18, color: AppColors.cyan500),
            ],
          ),
        ),
      ),
    );
  }
}
