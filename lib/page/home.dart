import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/theme_controller.dart';
import '../widgets/bottom_action_section.dart';
import '../widgets/charts_and_issues_section.dart';
import '../widgets/financial_kpi_section.dart';
import '../widgets/operations_kpi_section.dart';
import '../widgets/sidebar.dart';
import '../widgets/tables_and_donuts_section.dart';
import '../widgets/top_header.dart';
import 'settings.dart';

// =====================================================================
//  ROOT APP
// =====================================================================
class FantaSeaDashboardApp extends StatelessWidget {
  const FantaSeaDashboardApp({super.key});

  static ThemeData _buildTheme(Brightness brightness) {
    final palette =
        brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.cyan500,
        brightness: brightness,
      ),
      extensions: [palette],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, mode, _) => MaterialApp(
        title: 'AR Manager Dashboard',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: mode,
        home: const MainDashboardLayout(),
      ),
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

class MainDashboardLayout extends StatefulWidget {
  const MainDashboardLayout({super.key});

  @override
  State<MainDashboardLayout> createState() => _MainDashboardLayoutState();
}

class _MainDashboardLayoutState extends State<MainDashboardLayout> {
  int _selectedIndex = _dashboardIndex;

  @override
  Widget build(BuildContext context) {
    final Widget content;
    switch (_selectedIndex) {
      case _dashboardIndex:
        content = const SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FinancialKpiSection(),
              SizedBox(height: 20),
              OperationsKpiSection(),
              SizedBox(height: 20),
              ChartsAndIssuesSection(),
              SizedBox(height: 20),
              TablesAndDonutsSection(),
              SizedBox(height: 20),
              BottomActionSection(),
            ],
          ),
        );
      case _settingsIndex:
        content = const SettingsPage();
      default:
        content = _ComingSoon(title: _menuItems[_selectedIndex].title);
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SidebarWidget(
            items: _menuItems,
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: Column(
              children: [
                TopHeaderWidget(
                  title: _selectedIndex == _dashboardIndex
                      ? 'AR Manager Dashboard'
                      : _menuItems[_selectedIndex].title,
                ),
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_rounded, size: 40, color: p.textSubtle),
          const SizedBox(height: 12),
          Text('$title — coming soon',
              style: GoogleFonts.inter(fontSize: 14, color: p.textMuted)),
        ],
      ),
    );
  }
}
