import 'package:flutter/material.dart';

/// Accent colors that stay the same in light and dark mode.
/// Surface and text colors live in AppPalette (light & dark variants).
abstract final class AppColors {
  static const Color navy900 = Color(0xFF0A1628);
  static const Color navy800 = Color(0xFF0E2442);

  static const Color slate500 = Color(0xFF64748B);

  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color cyan500 = Color(0xFF06B6D4);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color sky500 = Color(0xFF0EA5E9);
  static const Color teal500 = Color(0xFF14B8A6);

  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);

  static const Color rose300 = Color(0xFFFDA4AF);
  static const Color rose500 = Color(0xFFF43F5E);
  static const Color pink500 = Color(0xFFEC4899);

  static const Color amber500 = Color(0xFFF59E0B);
  static const Color orange500 = Color(0xFFF97316);

  static const Color blue500 = Color(0xFF3B82F6);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);

  static const Color violet400 = Color(0xFFA78BFA);
  static const Color violet500 = Color(0xFF8B5CF6);
}
