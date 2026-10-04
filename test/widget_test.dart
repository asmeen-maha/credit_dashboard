import 'package:credit_dashboard/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Settings page switches between light and dark mode',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // The test font renders every glyph as a full square, so text is far
    // wider than with Inter and the fixed-width layout overflows. Ignore
    // overflow-only errors; anything else still fails the test.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.pumpWidget(const FantaSeaDashboardApp());

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);

    Brightness brightness() =>
        Theme.of(tester.element(find.text('Appearance'))).brightness;

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'light');
  });
}
