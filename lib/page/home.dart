import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/motion.dart';
import '../theme/neu.dart';
import '../theme/theme_controller.dart';
import '../widgets/sidebar.dart';
import '../widgets/top_header.dart';
import 'dashboard.dart';
import 'settings.dart';

// =====================================================================
//  ROOT APP
// =====================================================================
class FantaSeaDashboardApp extends StatelessWidget {
  const FantaSeaDashboardApp({super.key});

  static ThemeData _buildTheme(Brightness brightness, bool increaseContrast) {
    var palette =
        brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
    if (increaseContrast) palette = palette.highContrast();
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.bg,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.cyan500,
        brightness: brightness,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.tooltip,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(fontSize: 12, color: Colors.white),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(palette.textFaint.withOpacity(0.6)),
        radius: const Radius.circular(8),
      ),
      extensions: [palette],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(
          [ThemeController.instance, ContrastController.instance]),
      builder: (context, _) {
        final contrast = ContrastController.instance.value;
        return MaterialApp(
          title: 'AR Manager Dashboard',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light, contrast),
          darkTheme: _buildTheme(Brightness.dark, contrast),
          themeMode: ThemeController.instance.value,
          // Every surface, shadow and text color blends to the new mode.
          themeAnimationDuration: WidgetsBinding.instance.platformDispatcher
                  .accessibilityFeatures.disableAnimations
              ? Duration.zero
              : Motion.theme,
          themeAnimationCurve: Curves.easeInOutCubic,
          home: const MainDashboardLayout(),
        );
      },
    );
  }
}

// =====================================================================
//  1. MAIN LAYOUT
// =====================================================================
const List<SidebarMenuItem> _menuItems = [
  (icon: Icons.dashboard_rounded, title: 'Dashboard'),
  (icon: Icons.check_circle_outline_rounded, title: 'Sales Verification'),
  (icon: Icons.account_balance_wallet_outlined, title: 'AR & Collection'),
  (icon: Icons.people_alt_outlined, title: 'Agent Management'),
  (icon: Icons.bar_chart_rounded, title: 'Report'),
  (icon: Icons.settings_outlined, title: 'Setting'),
];

const int _dashboardIndex = 0;
const int _settingsIndex = 5;

/// Screen widths where the shell changes shape.
const double _railBreakpoint = 840; // below: sidebar moves into a drawer
const double _expandedBreakpoint = 1280; // below: sidebar shows icons only

class MainDashboardLayout extends StatefulWidget {
  const MainDashboardLayout({super.key});

  @override
  State<MainDashboardLayout> createState() => _MainDashboardLayoutState();
}

class _MainDashboardLayoutState extends State<MainDashboardLayout> {
  int _selectedIndex = _dashboardIndex;
  bool _userCollapsed = false;

  Widget _page(EdgeInsets padding) {
    switch (_selectedIndex) {
      case _dashboardIndex:
        return DashboardPage(padding: padding);
      case _settingsIndex:
        return SettingsPage(padding: padding);
      default:
        return _ComingSoon(title: _menuItems[_selectedIndex].title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final showRail = width >= _railBreakpoint;
        final canExpand = width >= _expandedBreakpoint;
        // Generous gaps leave room for the surfaces' soft shadows.
        final gap = showRail ? 28.0 : 16.0;
        final title = _selectedIndex != _dashboardIndex
            ? _menuItems[_selectedIndex].title
            : width < 600
                ? 'AR Dashboard'
                : 'AR Manager Dashboard';

        return Scaffold(
          drawer: showRail
              ? null
              : Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  width: SidebarWidget.expandedWidth + 24,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Builder(
                        builder: (drawerContext) => SidebarWidget(
                          items: _menuItems,
                          selectedIndex: _selectedIndex,
                          onSelect: (i) {
                            setState(() => _selectedIndex = i);
                            Navigator.of(drawerContext).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
          body: Stack(
            children: [
              SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showRail)
                      Padding(
                        padding: EdgeInsets.fromLTRB(gap, gap, 0, gap),
                        child: SidebarWidget(
                          items: _menuItems,
                          selectedIndex: _selectedIndex,
                          onSelect: (i) => setState(() => _selectedIndex = i),
                          collapsed: !canExpand || _userCollapsed,
                          onToggleCollapse: canExpand
                              ? () => setState(
                                  () => _userCollapsed = !_userCollapsed)
                              : null,
                        ),
                      ),
                    Expanded(
                      child: Stack(
                        children: [
                          // Content scrolls underneath the floating header
                          // and is clipped at the header's top edge.
                          Positioned(
                            top: gap,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: AnimatedSwitcher(
                              duration: reduceMotion
                                  ? Duration.zero
                                  : const Duration(milliseconds: 220),
                              // Pages fill the area instead of shrinking to
                              // their content and being centered.
                              child: SizedBox.expand(
                                key: ValueKey(_selectedIndex),
                                child: _page(EdgeInsets.fromLTRB(gap,
                                    gap + TopHeaderWidget.height, gap, gap)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: gap,
                            left: gap,
                            right: gap,
                            child: Builder(
                              builder: (context) => TopHeaderWidget(
                                title: title,
                                compact: width < 1100,
                                onMenu: showRail
                                    ? null
                                    : () => Scaffold.of(context).openDrawer(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;

  const _ComingSoon({required this.title});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NeuBox(
          radius: 28,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeuIconWell(Icons.construction_rounded, p.accent, size: 56),
              const SizedBox(height: 16),
              Text('$title — coming soon',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: p.textStrong)),
              const SizedBox(height: 4),
              Text('This section is under construction.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13, color: p.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
