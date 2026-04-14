import 'dart:convert';

import 'package:antinvestor_ui_core/analytics/analytics_models.dart';
import 'package:antinvestor_ui_core/analytics/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Generic REST-based analytics data source.
///
/// Calls `{baseUrl}/api/analytics/*` endpoints. Reusable across products —
/// the backend decides what data to return based on the `service` parameter.
class RestAnalyticsDataSource implements AnalyticsDataSource {
  RestAnalyticsDataSource(this._httpClient, this._baseUrl);

  final http.Client _httpClient;
  final String _baseUrl;

  @override
  Future<List<MetricValue>> getMetrics(
    String service, {
    AnalyticsTimeRange? timeRange,
  }) async {
    final params = {
      'service': service,
      ...?(timeRange?.toQueryParams()),
    };
    final uri = Uri.parse('$_baseUrl/api/analytics/metrics')
        .replace(queryParameters: params);

    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode != 200) return const [];
      final body = json.decode(response.body) as Map<String, dynamic>;
      final metrics = body['metrics'] as List<dynamic>? ?? [];
      return metrics.map((m) {
        final map = m as Map<String, dynamic>;
        final prev = map['previous_value'] as num?;
        return MetricValue(
          key: map['key'] as String,
          label: map['label'] as String,
          value: (map['value'] as num).toDouble(),
          previousValue: prev?.toDouble(),
          unit: map['unit'] as String?,
          icon: _iconFromName(map['icon'] as String?),
          trend: _parseTrend(map['trend'] as String?),
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<TimeSeries>> getTimeSeries(
    String service,
    String metric, {
    AnalyticsTimeRange? timeRange,
  }) async {
    final params = {
      'service': service,
      'metric': metric,
      ...?(timeRange?.toQueryParams()),
    };
    final uri = Uri.parse('$_baseUrl/api/analytics/timeseries')
        .replace(queryParameters: params);

    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode != 200) return const [];
      final body = json.decode(response.body) as Map<String, dynamic>;
      final series = body['series'] as List<dynamic>? ?? [];
      return series.map((s) {
        final map = s as Map<String, dynamic>;
        final points = (map['points'] as List<dynamic>? ?? []).map((p) {
          final pm = p as Map<String, dynamic>;
          return TimeSeriesPoint(
            timestamp: DateTime.parse(pm['timestamp'] as String),
            value: (pm['value'] as num).toDouble(),
          );
        }).toList();
        return TimeSeries(
          key: map['key'] as String,
          label: map['label'] as String? ?? map['key'] as String,
          points: points,
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<DistributionSegment>> getDistribution(
    String service,
    String metric,
    String groupBy, {
    AnalyticsTimeRange? timeRange,
  }) async {
    final params = {
      'service': service,
      'metric': metric,
      'group_by': groupBy,
      ...?(timeRange?.toQueryParams()),
    };
    final uri = Uri.parse('$_baseUrl/api/analytics/distribution')
        .replace(queryParameters: params);

    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode != 200) return const [];
      final body = json.decode(response.body) as Map<String, dynamic>;
      final segments = body['segments'] as List<dynamic>? ?? [];
      return segments.map((s) {
        final map = s as Map<String, dynamic>;
        return DistributionSegment(
          label: map['label'] as String,
          value: (map['value'] as num).toDouble(),
          color: map['color'] != null
              ? Color(int.parse((map['color'] as String).replaceFirst('#', '0xFF')))
              : null,
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<TopNItem>> getTopN(
    String service,
    String metric, {
    int limit = 10,
    AnalyticsTimeRange? timeRange,
  }) async {
    final params = {
      'service': service,
      'metric': metric,
      'limit': '$limit',
      ...?(timeRange?.toQueryParams()),
    };
    final uri = Uri.parse('$_baseUrl/api/analytics/top')
        .replace(queryParameters: params);

    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode != 200) return const [];
      final body = json.decode(response.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>? ?? [];
      return items.map((item) {
        final map = item as Map<String, dynamic>;
        return TopNItem(
          label: map['label'] as String,
          value: (map['value'] as num).toDouble(),
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  static IconData? _iconFromName(String? name) {
    if (name == null) return null;
    return switch (name) {
      'people' => Icons.people_outlined,
      'business' => Icons.business_outlined,
      'trending_up' => Icons.trending_up,
      'payments' => Icons.payments_outlined,
      'badge' => Icons.badge_outlined,
      _ => null,
    };
  }

  static MetricTrend? _parseTrend(String? trend) {
    if (trend == null) return null;
    return switch (trend) {
      'up' => MetricTrend.up,
      'down' => MetricTrend.down,
      'flat' => MetricTrend.flat,
      _ => null,
    };
  }
}
