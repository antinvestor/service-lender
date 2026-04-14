import 'package:antinvestor_api_files/antinvestor_api_files.dart';
import 'package:antinvestor_ui_core/api/api_base.dart';
import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

final filesTransportProvider = Provider<Transport>((ref) {
  final auth = ref.watch(authTokenProviderProvider);
  return createTransport(auth, baseUrl: AppConfig.filesBaseUrl);
});

final filesServiceClientProvider = Provider<FilesServiceClient>((ref) {
  final transport = ref.watch(filesTransportProvider);
  return FilesServiceClient(transport);
});
