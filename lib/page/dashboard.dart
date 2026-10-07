import 'package:flutter/material.dart';

import '../sections/attention_section.dart';
import '../sections/breakdown_section.dart';
import '../sections/overview_section.dart';
import '../sections/trends_section.dart';
import '../theme/neu.dart';
import '../widgets/dashboard_card.dart';

/// Dashboard ordered by what the AR manager needs first:
/// money position → what to act on today → trends → detail.
class DashboardPage extends StatelessWidget {
  final EdgeInsets padding;

  const DashboardPage({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - padding.horizontal;
        final wide = width >= 1040;
        final medium = width >= 680;
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeading(
                title: 'Financial overview',
                subtitle: 'Accounts receivable position as of today',
              ),
              FadeSlideIn(
                index: 0,
                child: OverviewSection(wide: width >= 900, compact: !medium),
              ),
              const SizedBox(height: 22),
              FadeSlideIn(
                index: 1,
                child: OperationsStrip(columns: wide ? 6 : (medium ? 3 : 2)),
              ),
              const SizedBox(height: 36),
              const SectionHeading(
                title: 'Needs attention today',
                subtitle: 'Issues and follow-ups to clear before end of day',
              ),
              FadeSlideIn(
                index: 2,
                child: AdaptiveRow(
                  wide: wide,
                  children: [
                    (4, const TopIssuesCard()),
                    (5, KeyActionsCard(compact: !medium)),
                    (3, const InsightsCard()),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const SectionHeading(
                title: 'Trends & targets',
                subtitle: 'How collection is moving against plan',
              ),
              FadeSlideIn(
                index: 3,
                child: AdaptiveRow(
                  wide: wide,
                  children: const [
                    (3, ArAgingCard()),
                    (5, CollectionTrendCard()),
                    (4, KpiSummaryCard()),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const SectionHeading(
                title: 'Breakdown',
                subtitle: 'AR by agent, status and aging bucket',
              ),
              FadeSlideIn(
                index: 4,
                child: AdaptiveRow(
                  wide: wide,
                  children: [
                    (5, AgentTableCard(compact: !medium)),
                    (3, const CollectionStatusCard()),
                    (3, const AgingDistributionCard()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
