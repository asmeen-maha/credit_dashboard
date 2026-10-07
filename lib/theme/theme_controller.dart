import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user's theme preference (system / light / dark) and persists it.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.system);

  static final ThemeController instance = ThemeController._();

  static const String _prefsKey = 'theme_mode';

  /// Loads the saved preference. Call once before [runApp].
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKey);
      value = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    } catch (_) {
      value = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.name);
    } catch (_) {
      // Preference still applies for this session even if saving fails.
    }
  }
}

/// "Increase contrast" accessibility preference: outlines around surfaces
/// and deeper shadows, for people who cannot see neumorphism's soft edges.
class ContrastController extends ValueNotifier<bool> {
  ContrastController._() : super(false);

  static final ContrastController instance = ContrastController._();

  static const String _prefsKey = 'increase_contrast';

  /// Loads the saved preference. Call once before [runApp].
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      value = prefs.getBool(_prefsKey) ?? false;
    } catch (_) {
      value = false;
    }
  }

  Future<void> setIncreased(bool increased) async {
    if (value == increased) return;
    value = increased;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, increased);
    } catch (_) {
      // Preference still applies for this session even if saving fails.
    }
  }
}
