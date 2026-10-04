import 'package:flutter/material.dart';
import 'page/home.dart';
import 'theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  runApp(const FantaSeaDashboardApp());
}
