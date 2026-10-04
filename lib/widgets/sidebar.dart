import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

typedef SidebarMenuItem = ({IconData icon, String title});

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<SidebarMenuItem> items;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(gradient: AppColors.sidebarGradient),
      child: Column(
        children: [
          // ── Logo ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PHUKET',
                  style: GoogleFonts.inter(
                    color: AppColors.cyan400.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('Fanta',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                    Text('Sea',
                        style: GoogleFonts.inter(
                            color: AppColors.cyan400,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // ── Menu Items ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                for (var i = 0; i < items.length; i++)
                  _SidebarItem(
                    icon: items[i].icon,
                    title: items[i].title,
                    isActive: i == selectedIndex,
                    onTap: () => onSelect(i),
                  ),
              ],
            ),
          ),
          // ── Footer ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cyan400.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.park_rounded,
                      color: AppColors.cyan400, size: 24),
                ),
                const SizedBox(height: 8),
                Text('Amazing Thailand',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Becomes More Amazing',
                    style: GoogleFonts.inter(
                        color: AppColors.slate400, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: active
                ? AppColors.cyan400.withOpacity(0.12)
                : _hovering
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active
                ? Border.all(
                    color: AppColors.cyan400.withOpacity(0.2), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon,
                  color: active ? AppColors.cyan400 : AppColors.slate400,
                  size: 20),
              const SizedBox(width: 12),
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  color: active ? Colors.white : AppColors.slate300,
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
