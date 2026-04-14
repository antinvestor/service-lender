import 'dart:typed_data';

import 'package:antinvestor_api_files/antinvestor_api_files.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'files_provider.dart';

/// Upload image bytes to the files service as a public image.
/// Returns the content_uri for the uploaded file.
Future<String> uploadPublicImage(
  WidgetRef ref,
  Uint8List bytes,
  String filename, {
  String? accessorId,
}) async {
  final client = ref.read(filesServiceClientProvider);

  // Use provided accessorId or default to 'public_access' (must match [0-9a-z_-]{3,40}).
  final accessors = [accessorId ?? 'public_access'];

  // Send metadata + full bytes in a single request message.
  // Connect web transport may not support multi-message client streaming,
  // so we combine metadata and chunk into one message.
  final request = UploadContentRequest(
    metadata: UploadMetadata(
      contentType: _contentTypeForFilename(filename),
      filename: filename,
      totalSize: Int64(bytes.length),
      visibility: MediaMetadata_Visibility.VISIBILITY_PUBLIC,
      accessorId: accessors,
    ),
    chunk: bytes,
  );

  final response = await client.uploadContent(
    Stream.fromIterable([request]),
  );
  return response.contentUri;
}

String _contentTypeForFilename(String filename) {
  final lower = filename.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  return 'application/octet-stream';
}
