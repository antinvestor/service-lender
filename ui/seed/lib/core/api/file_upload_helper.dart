import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/auth_repository.dart';
import '../config/app_config.dart';

/// Upload image bytes to the files service as a public image.
///
/// Uses the HTTP multipart upload endpoint at /v1/media/upload
/// which is the standard upload path for the files service.
/// Returns the content_uri (mxc:// URL) for the uploaded file.
Future<String> uploadPublicImage(
  WidgetRef ref,
  Uint8List bytes,
  String filename,
) async {
  final authRepo = ref.read(authRepositoryProvider);
  final token = await authRepo.getAccessToken();
  if (token == null) throw Exception('Not authenticated');

  final uri = Uri.parse(
      '${AppConfig.filesBaseUrl}/v1/media/upload?filename=${Uri.encodeComponent(filename)}');

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filename,
    ));

  debugPrint('[FileUpload] Uploading ${bytes.length} bytes to $uri');

  final streamedResponse = await request.send();
  final body = await streamedResponse.stream.bytesToString();

  debugPrint('[FileUpload] Response ${streamedResponse.statusCode}: $body');

  if (streamedResponse.statusCode != 200) {
    throw Exception('Upload failed (${streamedResponse.statusCode}): $body');
  }

  final data = jsonDecode(body) as Map<String, dynamic>;
  final contentUri = data['content_uri'] as String?;
  if (contentUri == null || contentUri.isEmpty) {
    throw Exception('Upload succeeded but no content_uri in response');
  }

  // Convert mxc:// URI to HTTP download URL.
  // mxc://server_name/media_id → {filesBaseUrl}/v1/media/download/server_name/media_id
  final httpUrl = mxcToHttpUrl(contentUri);
  debugPrint('[FileUpload] Content URI: $contentUri → $httpUrl');
  return httpUrl;
}

/// Convert an mxc:// content URI to an HTTP download URL.
///
/// Format: mxc://server_name/media_id
/// Result: {filesBaseUrl}/v1/media/download/server_name/media_id
String mxcToHttpUrl(String mxcUri) {
  if (!mxcUri.startsWith('mxc://')) return mxcUri; // already HTTP
  final parts = mxcUri.substring(6).split('/'); // remove "mxc://"
  if (parts.length < 2) return mxcUri;
  final serverName = parts[0];
  final mediaId = parts[1];
  return '${AppConfig.filesBaseUrl}/v1/media/download/$serverName/$mediaId';
}
