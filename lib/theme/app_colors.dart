import 'package:flutter/material.dart';

/// Accent colors that stay the same in light and dark mode.
/// Neutral surface/text colors live in AppPalette (light & dark variants).
abstract final class AppColors {
  static const Color navy900 = Color(0xFF0A1628);
  static const Color navy800 = Color(0xFF0E2442);

  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);

  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color cyan500 = Color(0xFF06B6D4);

  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);

  static const Color rose500 = Color(0xFFF43F5E);
  static const Color rose600 = Color(0xFFE11D48);

  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);

  static const Color blue500 = Color(0xFF3B82F6);

  static const Color violet500 = Color(0xFF8B5CF6);

  // ─── Gradient Presets ─────────────────────────────────────────────
  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navy800, navy900],
  );
}
