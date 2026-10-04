import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class OperationsKpiSection extends StatelessWidget {
  const OperationsKpiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy800, AppColors.navy900.withOpacity(0.95)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy900.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildOpKpi(
            icon: Icons.receipt_long_rounded,
            label: 'Invoices Today',
            value: '142',
            accent: AppColors.cyan400,
          ),
          _divider(),
          _buildOpKpi(
            icon: Icons.payments_rounded,
            label: 'Collected',
            value: '฿ 4.2M',
            accent: AppColors.emerald400,
          ),
          _divider(),
          _buildOpKpi(
            icon: Icons.assignment_turned_in_rounded,
            label: 'Collection Rate',
            value: '82.4%',
            accent: const Color(0xFF818CF8),
          ),
          _divider(),
          _buildOpKpi(
            icon: Icons.phone_callback_rounded,
            label: 'Follow-ups Done',
            value: '67 / 85',
            accent: AppColors.amber500,
          ),
          _divider(),
          _buildOpKpi(
            icon: Icons.gavel_rounded,
            label: 'Disputes Open',
            value: '12',
            accent: AppColors.rose500,
          ),
          _divider(),
          _buildOpKpi(
            icon: Icons.speed_rounded,
            label: 'DSO (Days)',
            value: '38',
            accent: const Color(0xFF06B6D4),
          ),
        ],
      ),
    );
  }

  static Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white.withOpacity(0.08),
    );
  }

  static Widget _buildOpKpi({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.slate400,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(value,
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
