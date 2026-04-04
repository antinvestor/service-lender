/// Helpers for consuming paginated gRPC streams safely.

/// Collects items from a paginated server stream with a maximum page cap
/// to prevent unbounded memory growth.
///
/// [stream] is the gRPC response stream. [extract] pulls the list of items
/// from each response message. [maxPages] limits how many pages are consumed
/// (default 10). Returns the accumulated list.
Future<List<T>> collectStream<R, T>(
  Stream<R> stream, {
  required List<T> Function(R response) extract,
  int maxPages = 10,
}) async {
  final results = <T>[];
  var pages = 0;
  await for (final response in stream) {
    final items = extract(response);
    results.addAll(items);
    if (++pages >= maxPages || items.isEmpty) break;
  }
  return results;
}

/// Counts items from a paginated server stream with a maximum page cap.
/// Only accumulates the count, not the items themselves.
Future<int> countStream<R>(
  Stream<R> stream, {
  required int Function(R response) count,
  int maxPages = 20,
}) async {
  var total = 0;
  var pages = 0;
  await for (final response in stream) {
    final c = count(response);
    total += c;
    if (++pages >= maxPages || c == 0) break;
  }
  return total;
}
