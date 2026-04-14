import 'package:antinvestor_ui_core/analytics/analytics_dashboard.dart';
import 'package:flutter/material.dart';

/// Dashboard reserved for product/service analytics with partition drill-down.
///
/// Uses ui_core's [AnalyticsDashboard] to display metrics, charts, and
/// tables scoped to the current partition. Users can drill down into
/// child partitions to see granular data.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnalyticsDashboard(
      service: 'identity',
      title: 'Seed Analytics',
      metrics: [
        'total_organizations',
        'active_organizations',
        'total_workforce',
        'active_workforce',
      ],
      charts: [
        ChartConfig.timeSeries('onboarding_rate',
            label: 'Onboarding Over Time'),
        ChartConfig.distribution('org_types',
            groupBy: 'org_type', label: 'By Organization Type'),
      ],
      tables: [
        TableConfig.topN('top_organizations',
            label: 'Largest Organizations', limit: 10),
      ],
    );
  }
}
