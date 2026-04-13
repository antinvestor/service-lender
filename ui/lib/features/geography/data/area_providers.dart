import 'package:antinvestor_api_geolocation/antinvestor_api_geolocation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';

part 'area_providers.g.dart';

@riverpod
Future<List<AreaObject>> areaSearch(
  Ref ref, {
  String query = '',
  int limit = 20,
}) async {
  final trimmedQuery = query.trim();
  if (trimmedQuery.length < 2) {
    return const <AreaObject>[];
  }

  final client = ref.watch(geolocationServiceClientProvider);
  final response = await client.searchAreas(
    SearchAreasRequest(query: trimmedQuery, limit: limit),
  );
  return response.data;
}

@riverpod
Future<AreaObject?> areaById(Ref ref, String id) async {
  if (id.trim().isEmpty) {
    return null;
  }

  final client = ref.watch(geolocationServiceClientProvider);
  final response = await client.getArea(GetAreaRequest(id: id));
  return response.data;
}
