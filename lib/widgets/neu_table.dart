import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_palette.dart';
import '../theme/neu.dart';

/// Pressed-in well that holds a table: a header row, then rows separated
/// by thin lines.
class NeuTable extends StatelessWidget {
  final List<Widget> header;
  final List<List<Widget>> rows;

  const NeuTable({super.key, required this.header, required this.rows});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      inset: true,
      radius: 18,
      distance: 4,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(children: header),
          ),
          for (final cells in rows)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: p.line)),
              ),
              child: Row(children: cells),
            ),
        ],
      ),
    );
  }

  static TextStyle headStyle(AppPalette p) => GoogleFonts.inter(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: p.textSubtle);
}
