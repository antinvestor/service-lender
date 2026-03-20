import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/lender/v1/loan_management.pb.dart';

part 'schedule_providers.g.dart';

@riverpod
Future<RepaymentScheduleObject> repaymentScheduleDetail(
  Ref ref, {
  required String loanAccountId,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final response = await client.repaymentScheduleGet(
    RepaymentScheduleGetRequest(loanAccountId: loanAccountId),
  );
  return response.data;
}
