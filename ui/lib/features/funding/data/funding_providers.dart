import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/funding/v1/funding.pb.dart';

part 'funding_providers.g.dart';

// ---------------------------------------------------------------------------
// Investor Accounts
// ---------------------------------------------------------------------------

@riverpod
Future<List<InvestorAccountObject>> investorAccountList(
  Ref ref, {
  String investorId = '',
}) async {
  final client = ref.watch(fundingServiceClientProvider);
  final request = InvestorAccountSearchRequest(
    cursor: PageCursor(limit: 50),
  );
  if (investorId.isNotEmpty) {
    request.investorId = investorId;
  }
  return collectStream(
    client.investorAccountSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
Future<InvestorAccountObject> investorAccountDetail(
  Ref ref,
  String id,
) async {
  final client = ref.watch(fundingServiceClientProvider);
  final response = await client.investorAccountGet(
    InvestorAccountGetRequest(id: id),
  );
  return response.data;
}

@riverpod
class InvestorAccountNotifier extends _$InvestorAccountNotifier {
  @override
  FutureOr<void> build() {}

  Future<InvestorAccountObject> save(InvestorAccountObject account) async {
    final client = ref.read(fundingServiceClientProvider);
    final response = await client.investorAccountSave(
      InvestorAccountSaveRequest(data: account),
    );
    ref.invalidate(investorAccountListProvider);
    return response.data;
  }

  Future<InvestorAccountObject> deposit({
    required String accountId,
    required dynamic amount,
  }) async {
    final client = ref.read(fundingServiceClientProvider);
    final response = await client.investorDeposit(
      InvestorDepositRequest(accountId: accountId, amount: amount),
    );
    ref.invalidate(investorAccountDetailProvider(accountId));
    ref.invalidate(investorAccountListProvider);
    return response.data;
  }

  Future<InvestorAccountObject> withdraw({
    required String accountId,
    required dynamic amount,
  }) async {
    final client = ref.read(fundingServiceClientProvider);
    final response = await client.investorWithdraw(
      InvestorWithdrawRequest(accountId: accountId, amount: amount),
    );
    ref.invalidate(investorAccountDetailProvider(accountId));
    ref.invalidate(investorAccountListProvider);
    return response.data;
  }

  Future<FundLoanResponse> fundLoan({required String loanRequestId}) async {
    final client = ref.read(fundingServiceClientProvider);
    final response = await client.fundLoan(
      FundLoanRequest(loanRequestId: loanRequestId),
    );
    ref.invalidate(investorAccountListProvider);
    return response;
  }

  Future<void> absorbLoss({
    required String loanRequestId,
    required dynamic amount,
  }) async {
    final client = ref.read(fundingServiceClientProvider);
    await client.absorbLoss(
      AbsorbLossRequest(loanRequestId: loanRequestId, amount: amount),
    );
    ref.invalidate(investorAccountListProvider);
  }
}
