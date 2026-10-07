import 'package:flutter/material.dart';

/// Neumorphic surface and text colors that change between light and dark
/// mode. Accent colors (blue, emerald, rose, ...) live in AppColors.
///
/// Every surface uses the same [bg]; depth comes only from a dark shadow
/// (bottom-right) and a light shadow (top-left). Because those soft edges
/// are low-contrast by nature, text tokens down to [textSubtle] are kept at
/// WCAG AA (4.5:1) on [bg]; [textFaint] is for decoration only.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Brightness brightness;

  final Color bg;
  final Color shadowDark;
  final Color shadowLight;

  /// Edge drawn around surfaces. Transparent unless "Increase contrast".
  final Color outline;

  final Color line;
  final Color trackFlat;
  final Color scrim;
  final Color tooltip;

  /// Text, from strongest to faintest.
  final Color textStrong;
  final Color text;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;
  final Color textFaint;

  /// Brand cyan tuned for contrast against [bg].
  final Color accent;

  const AppPalette({
    required this.brightness,
    required this.bg,
    required this.shadowDark,
    required this.shadowLight,
    required this.outline,
    required this.line,
    required this.trackFlat,
    required this.scrim,
    required this.tooltip,
    required this.textStrong,
    required this.text,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
    required this.textFaint,
    required this.accent,
  });

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  bool get isDark => brightness == Brightness.dark;

  /// Accent color adjusted so small text in that color stays readable
  /// on [bg] (500-level accents are too light on grey, too dull on slate).
  Color onAccent(Color color) => isDark
      ? Color.lerp(color, Colors.white, 0.35)!
      : Color.lerp(color, Colors.black, 0.38)!;

  /// Extruded look: dark shadow bottom-right, light shadow top-left.
  List<BoxShadow> raised(double distance) => [
        BoxShadow(
          color: shadowDark,
          offset: Offset(distance, distance),
          blurRadius: distance * 2,
        ),
        BoxShadow(
          color: shadowLight,
          offset: Offset(-distance, -distance),
          blurRadius: distance * 2,
        ),
      ];

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    bg: Color(0xFFE4E9F0),
    shadowDark: Color(0x8C94A3B8),
    shadowLight: Color(0xF2FFFFFF),
    outline: Colors.transparent,
    line: Color(0x2E64748B),
    trackFlat: Color(0x2E64748B),
    scrim: Color(0xB3E4E9F0),
    tooltip: Color(0xF018212F),
    textStrong: Color(0xFF18212F),
    text: Color(0xFF1E293B),
    textBody: Color(0xFF334155),
    textMuted: Color(0xFF465366),
    textSubtle: Color(0xFF556275),
    textFaint: Color(0xFF94A3B8),
    accent: Color(0xFF0E7490),
  );

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    bg: Color(0xFF262B33),
    shadowDark: Color(0x80000000),
    shadowLight: Color(0x0EFFFFFF),
    outline: Colors.transparent,
    line: Color(0x12FFFFFF),
    trackFlat: Color(0x14FFFFFF),
    scrim: Color(0xB314171C),
    tooltip: Color(0xF0111418),
    textStrong: Color(0xFFEEF2F7),
    text: Color(0xFFE2E8F0),
    textBody: Color(0xFFC9D1DC),
    textMuted: Color(0xFFA9B4C2),
    textSubtle: Color(0xFF97A3B3),
    textFaint: Color(0xFF5B6575),
    accent: Color(0xFF22D3EE),
  );

  /// "Increase contrast": visible outlines and deeper shadows, so surfaces
  /// stay distinguishable for people who cannot see soft edges.
  AppPalette highContrast() {
    return copyWith(
      outline: isDark ? const Color(0x59FFFFFF) : const Color(0x6B334155),
      shadowDark: isDark ? const Color(0xB3000000) : const Color(0xB394A3B8),
    );
  }

  @override
  AppPalette copyWith({Color? outline, Color? shadowDark}) {
    return AppPalette(
      brightness: brightness,
      bg: bg,
      shadowDark: shadowDark ?? this.shadowDark,
      shadowLight: shadowLight,
      outline: outline ?? this.outline,
      line: line,
      trackFlat: trackFlat,
      scrim: scrim,
      tooltip: tooltip,
      textStrong: textStrong,
      text: text,
      textBody: textBody,
      textMuted: textMuted,
      textSubtle: textSubtle,
      textFaint: textFaint,
      accent: accent,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      bg: Color.lerp(bg, other.bg, t)!,
      shadowDark: Color.lerp(shadowDark, other.shadowDark, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      line: Color.lerp(line, other.line, t)!,
      trackFlat: Color.lerp(trackFlat, other.trackFlat, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      tooltip: Color.lerp(tooltip, other.tooltip, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      text: Color.lerp(text, other.text, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
