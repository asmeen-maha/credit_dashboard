import 'package:credit_dashboard/page/home.dart';
import 'package:credit_dashboard/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renders the dashboard at desktop, tablet and phone widths in both
/// modes to catch layout exceptions (e.g. intrinsic-size or unbounded
/// height errors) introduced by the responsive layout.
void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpAt(WidgetTester tester, Size size,
      {bool settle = true}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // The test font renders every glyph as a full square, so text is far
    // wider than with Inter. Ignore overflow-only errors; anything else
    // still fails the test.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.pumpWidget(const FantaSeaDashboardApp());
    if (settle) await tester.pumpAndSettle();
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final size in const [
      Size(1920, 1200),
      Size(1100, 900),
      Size(700, 1000),
      Size(390, 844),
    ]) {
      testWidgets('dashboard renders at ${size.width.toInt()}px, ${mode.name}',
          (tester) async {
        ThemeController.instance.value = mode;
        addTearDown(() => ThemeController.instance.value = ThemeMode.system);
        await pumpAt(tester, size);

        expect(find.text('Top 3 Issues Today'), findsOneWidget);
        expect(find.text('Financial overview'), findsOneWidget);

        await tester.drag(
            find.byType(SingleChildScrollView).first, const Offset(0, -3000));
        await tester.pumpAndSettle();
        expect(find.text('AR by Agent'), findsOneWidget);
      });
    }
  }

  testWidgets('phone layout opens navigation from the header menu',
      (tester) async {
    await pumpAt(tester, const Size(390, 844));
    expect(find.text('Setting'), findsNothing);

    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
  });

  testWidgets('tapping an issue opens its detail dialog', (tester) async {
    await pumpAt(tester, const Size(1920, 1200));
    await tester.tap(find.text('Package Mismatch'));
    await tester.pumpAndSettle();
    expect(find.text('23 open cases'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('23 open cases'), findsNothing);
  });

  testWidgets('increase contrast persists', (tester) async {
    addTearDown(() => ContrastController.instance.value = false);
    await pumpAt(tester, const Size(1920, 1200));
    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Increase contrast'));
    await tester.pumpAndSettle();
    expect(ContrastController.instance.value, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('increase_contrast'), isTrue);
  });

  testWidgets('numbers count up to their final values', (tester) async {
    await pumpAt(tester, const Size(1920, 1200), settle: false);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('฿ 68.45M'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('฿ 68.45M'), findsOneWidget);
    expect(find.text('฿ 52.78M'), findsOneWidget);
    expect(find.text('67 / 85'), findsOneWidget);
    expect(find.text('82.4%'), findsWidgets);
  });

  testWidgets('reduced motion shows final values without animating',
      (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await pumpAt(tester, const Size(1920, 1200), settle: false);
    await tester.pump();
    expect(find.text('฿ 68.45M'), findsOneWidget);
    expect(find.text('฿ 68.5M'), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('charts below the fold animate only once scrolled into view',
      (tester) async {
    await pumpAt(tester, const Size(1920, 1200));
    // The aging donut sits far below the first screen: still at zero.
    expect(find.text('฿ 68.5M'), findsNothing);

    await tester.drag(
        find.byType(SingleChildScrollView).first, const Offset(0, -3000));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('฿ 68.5M'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('฿ 68.5M'), findsOneWidget);
  });
}
