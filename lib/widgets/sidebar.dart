import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_palette.dart';
import '../theme/neu.dart';

typedef SidebarMenuItem = ({IconData icon, String title});

/// Raised neumorphic navigation slab; the active item is pressed in.
/// [collapsed] shows icons only (with tooltips); [onToggleCollapse] adds a
/// collapse/expand button when non-null.
class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<SidebarMenuItem> items;
  final bool collapsed;
  final VoidCallback? onToggleCollapse;

  static const double expandedWidth = 248;
  static const double collapsedWidth = 88;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.items,
    this.collapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedContainer(
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: collapsed ? collapsedWidth : expandedWidth,
      child: NeuBox(
        radius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Logo ──
            SizedBox(
              height: 48,
              child: _clipped(Row(
                children: [
                  NeuBox(
                    radius: 14,
                    distance: 5,
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Text('FS',
                          semanticsLabel: collapsed ? 'FantaSea' : '',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: p.accent)),
                    ),
                  ),
                  if (!collapsed) ...[
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PHUKET',
                            style: GoogleFonts.inter(
                              color: p.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            )),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: 'Fanta',
                                style: TextStyle(color: p.textStrong)),
                            TextSpan(
                                text: 'Sea', style: TextStyle(color: p.accent)),
                          ]),
                          style: GoogleFonts.inter(
                              fontSize: 21, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ],
              )),
            ),
            const SizedBox(height: 18),
            // ── Menu Items ──
            Expanded(
              child: Semantics(
                container: true,
                label: 'Main navigation',
                child: Material(
                  type: MaterialType.transparency,
                  child: ListView(
                    // Room for the pressed item's shadows at the edges.
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      for (var i = 0; i < items.length; i++)
                        _SidebarItem(
                          icon: items[i].icon,
                          title: items[i].title,
                          isActive: i == selectedIndex,
                          collapsed: collapsed,
                          onTap: () => onSelect(i),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Footer ──
            if (!collapsed)
              NeuBox(
                inset: true,
                radius: 18,
                distance: 4,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amazing Thailand',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.inter(
                            color: p.textStrong,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('Becomes More Amazing',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.inter(
                            color: p.textSubtle, fontSize: 11)),
                  ],
                ),
              ),
            if (onToggleCollapse != null)
              Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment:
                      collapsed ? Alignment.center : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: IconButton(
                      tooltip:
                          collapsed ? 'Expand sidebar' : 'Collapse sidebar',
                      onPressed: onToggleCollapse,
                      icon: Icon(
                        collapsed
                            ? Icons.keyboard_double_arrow_right_rounded
                            : Icons.keyboard_double_arrow_left_rounded,
                        color: p.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Keeps the logo from overflowing while the width animates.
  /// Only for children with a bounded height.
  static Widget _clipped(Widget child) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: 0,
        maxWidth: expandedWidth - 32,
        child: child,
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool collapsed;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.collapsed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final active = isActive;
    final iconWidget =
        Icon(icon, color: active ? p.accent : p.textMuted, size: 20);
    final label = collapsed
        ? Center(child: iconWidget)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.inter(
                      color: active ? p.accent : p.textBody,
                      fontSize: 13.5,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );

    Widget item = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: p.line,
        focusColor: p.accent.withOpacity(0.18),
        child: active
            ? NeuBox(
                inset: true,
                radius: 16,
                distance: 4,
                height: 48,
                child: label,
              )
            : SizedBox(height: 48, child: label),
      ),
    );

    if (collapsed) {
      item = Tooltip(
          message: title, preferBelow: false, verticalOffset: 0, child: item);
    }
    return Semantics(
      selected: active,
      button: true,
      label: collapsed ? title : null,
      child: item,
    );
  }
}
