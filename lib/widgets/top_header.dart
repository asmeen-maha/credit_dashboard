import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class TopHeaderWidget extends StatelessWidget {
  final String title;

  const TopHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        gradient: p.headerGradient,
        border: Border(
          bottom: BorderSide(color: p.gridLine, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: p.textStrong)),
              const SizedBox(height: 4),
              Row(
                children: [
                  _headerPill('Better Data', AppColors.blue500),
                  _headerDot(p),
                  _headerPill('Faster Process', AppColors.emerald500),
                  _headerDot(p),
                  _headerPill('Healthier Cash Flow', AppColors.violet500),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Date badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: p.surface,
                  border: Border.all(color: p.gridLine),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: p.textSubtle),
                    const SizedBox(width: 8),
                    Text('20 Sep 2026',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    Text('  ·  17:00',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: p.textSubtle)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Profile
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.cyan400, AppColors.blue500],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan400.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.navy800,
                  child:
                      Icon(Icons.person_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AR Manager',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: p.textStrong)),
                  Text('Credit & Collection',
                      style:
                          GoogleFonts.inter(fontSize: 11, color: p.textSubtle)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _headerPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }

  static Widget _headerDot(AppPalette p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: p.textFaint,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
