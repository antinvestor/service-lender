import 'dart:math';

/// Generates a collision-resistant 32-hex-char idempotency key
/// using a cryptographically secure random number generator.
String generateIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
