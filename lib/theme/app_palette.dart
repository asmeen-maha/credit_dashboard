import 'package:flutter/material.dart';

/// Neutral surface / text colors that change between light and dark mode.
/// Accent colors (blue, emerald, rose, ...) stay the same in both modes.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color gridLine;
  final Color track;

  /// Text, from strongest to faintest.
  final Color textStrong;
  final Color text;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;
  final Color textFaint;

  final LinearGradient headerGradient;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> elevatedShadow;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.gridLine,
    required this.track,
    required this.textStrong,
    required this.text,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
    required this.textFaint,
    required this.headerGradient,
    required this.cardShadow,
    required this.elevatedShadow,
  });

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  static const AppPalette light = AppPalette(
    background: Color(0xFFF8FAFC),
    surface: Colors.white,
    surfaceMuted: Color(0xFFF8FAFC),
    border: Color(0xFFF1F5F9),
    gridLine: Color(0xFFE2E8F0),
    track: Color(0xFFF1F5F9),
    textStrong: Color(0xFF1E293B),
    text: Color(0xFF334155),
    textBody: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    textSubtle: Color(0xFF94A3B8),
    textFaint: Color(0xFFCBD5E1),
    headerGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
    ),
    cardShadow: [
      BoxShadow(color: Color(0x0A0F172A), blurRadius: 12, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x050F172A), blurRadius: 4, offset: Offset(0, 2)),
    ],
    elevatedShadow: [
      BoxShadow(color: Color(0x140F172A), blurRadius: 24, offset: Offset(0, 8)),
      BoxShadow(color: Color(0x0A0F172A), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF0B1220),
    surface: Color(0xFF131C2E),
    surfaceMuted: Color(0xFF1A2438),
    border: Color(0xFF1E293B),
    gridLine: Color(0xFF334155),
    track: Color(0xFF1E293B),
    textStrong: Color(0xFFF1F5F9),
    text: Color(0xFFE2E8F0),
    textBody: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    textSubtle: Color(0xFF64748B),
    textFaint: Color(0xFF475569),
    headerGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF0F172A), Color(0xFF111C33)],
    ),
    cardShadow: [
      BoxShadow(color: Color(0x40000000), blurRadius: 12, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x20000000), blurRadius: 4, offset: Offset(0, 2)),
    ],
    elevatedShadow: [
      BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8)),
      BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      track: Color.lerp(track, other.track, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      text: Color.lerp(text, other.text, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      headerGradient:
          LinearGradient.lerp(headerGradient, other.headerGradient, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
      elevatedShadow:
          BoxShadow.lerpList(elevatedShadow, other.elevatedShadow, t)!,
    );
  }
}
