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

  // Use provided accessorId or default to '*' (public access).
  final accessors = [accessorId ?? '*'];

  // Build the upload stream: first metadata, then chunks.
  final requests = <UploadContentRequest>[
    UploadContentRequest(
      metadata: UploadMetadata(
        contentType: _contentTypeForFilename(filename),
        filename: filename,
        totalSize: Int64(bytes.length),
        visibility: MediaMetadata_Visibility.VISIBILITY_PUBLIC,
        accessorId: accessors,
      ),
    ),
    // Send bytes in chunks of 64 KB.
    for (var offset = 0; offset < bytes.length; offset += 65536)
      UploadContentRequest(
        chunk: bytes.sublist(offset, (offset + 65536).clamp(0, bytes.length)),
      ),
  ];

  final response = await client.uploadContent(Stream.fromIterable(requests));
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
