import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/savings/v1/savings.pb.dart';

part 'savings_providers.g.dart';

// ---------------------------------------------------------------------------
// Savings Products
// ---------------------------------------------------------------------------

@riverpod
Future<List<SavingsProductObject>> savingsProductList(
  Ref ref,
  String query,
) async {
  final client = ref.watch(savingsServiceClientProvider);
  final request = SavingsProductSearchRequest(
    query: query,
    cursor: PageCursor(limit: 50),
  );
  return collectStream(
    client.savingsProductSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class SavingsProductNotifier extends _$SavingsProductNotifier {
  @override
  FutureOr<void> build() {}

  Future<SavingsProductObject> save(SavingsProductObject product) async {
    final client = ref.read(savingsServiceClientProvider);
    final response = await client
        .savingsProductSave(SavingsProductSaveRequest(data: product));
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(savingsProductListProvider);
    });
    return response.data;
  }
}

// ---------------------------------------------------------------------------
// Savings Accounts
// ---------------------------------------------------------------------------

@riverpod
Future<List<SavingsAccountObject>> savingsAccountList(
  Ref ref, {
  required String query,
  String ownerId = '',
}) async {
  final client = ref.watch(savingsServiceClientProvider);
  final request = SavingsAccountSearchRequest(
    query: query,
    cursor: PageCursor(limit: 50),
  );
  if (ownerId.isNotEmpty) {
    request.ownerId = ownerId;
  }
  return collectStream(
    client.savingsAccountSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
Future<SavingsAccountObject> savingsAccountDetail(
  Ref ref,
  String id,
) async {
  final client = ref.watch(savingsServiceClientProvider);
  final response =
      await client.savingsAccountGet(SavingsAccountGetRequest(id: id));
  return response.data;
}

@riverpod
Future<SavingsBalanceObject> savingsBalance(
  Ref ref,
  String accountId,
) async {
  final client = ref.watch(savingsServiceClientProvider);
  final response = await client
      .savingsBalanceGet(SavingsBalanceGetRequest(savingsAccountId: accountId));
  return response.data;
}

@riverpod
class SavingsAccountNotifier extends _$SavingsAccountNotifier {
  @override
  FutureOr<void> build() {}

  Future<SavingsAccountObject> create(SavingsAccountObject account) async {
    final client = ref.read(savingsServiceClientProvider);
    final response = await client
        .savingsAccountCreate(SavingsAccountCreateRequest(data: account));
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(savingsAccountListProvider);
    });
    return response.data;
  }

  Future<void> freeze(String id) async {
    final client = ref.read(savingsServiceClientProvider);
    await client
        .savingsAccountFreeze(SavingsAccountFreezeRequest(id: id));
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(savingsAccountListProvider);
      ref.invalidate(savingsAccountDetailProvider);
    });
  }

  Future<void> close(String id) async {
    final client = ref.read(savingsServiceClientProvider);
    await client
        .savingsAccountClose(SavingsAccountCloseRequest(id: id));
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(savingsAccountListProvider);
      ref.invalidate(savingsAccountDetailProvider);
    });
  }
}

// ---------------------------------------------------------------------------
// Deposits
// ---------------------------------------------------------------------------

@riverpod
Future<List<DepositObject>> depositList(
  Ref ref, {
  required String savingsAccountId,
}) async {
  final client = ref.watch(savingsServiceClientProvider);
  final request = DepositSearchRequest(
    savingsAccountId: savingsAccountId,
    cursor: PageCursor(limit: 50),
  );
  return collectStream(
    client.depositSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class DepositNotifier extends _$DepositNotifier {
  @override
  FutureOr<void> build() {}

  Future<DepositObject> record({
    required String savingsAccountId,
    required dynamic amount,
    String paymentReference = '',
    String channel = '',
    String payerReference = '',
  }) async {
    final client = ref.read(savingsServiceClientProvider);
    final response = await client.depositRecord(DepositRecordRequest(
      savingsAccountId: savingsAccountId,
      amount: amount,
      paymentReference: paymentReference,
      channel: channel,
      payerReference: payerReference,
      idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
    ));
    ref.invalidate(depositListProvider);
    ref.invalidate(savingsBalanceProvider);
    return response.data;
  }
}

// ---------------------------------------------------------------------------
// Withdrawals
// ---------------------------------------------------------------------------

@riverpod
Future<List<WithdrawalObject>> withdrawalList(
  Ref ref, {
  required String savingsAccountId,
}) async {
  final client = ref.watch(savingsServiceClientProvider);
  final request = WithdrawalSearchRequest(
    savingsAccountId: savingsAccountId,
    cursor: PageCursor(limit: 50),
  );
  return collectStream(
    client.withdrawalSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class WithdrawalNotifier extends _$WithdrawalNotifier {
  @override
  FutureOr<void> build() {}

  Future<WithdrawalObject> request({
    required String savingsAccountId,
    required dynamic amount,
    String channel = '',
    String recipientReference = '',
    String reason = '',
  }) async {
    final client = ref.read(savingsServiceClientProvider);
    final response =
        await client.withdrawalRequest(WithdrawalRequestRequest(
      savingsAccountId: savingsAccountId,
      amount: amount,
      channel: channel,
      recipientReference: recipientReference,
      reason: reason,
      idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
    ));
    ref.invalidate(withdrawalListProvider);
    ref.invalidate(savingsBalanceProvider);
    return response.data;
  }

  Future<WithdrawalObject> approve(String id) async {
    final client = ref.read(savingsServiceClientProvider);
    final response =
        await client.withdrawalApprove(WithdrawalApproveRequest(id: id));
    ref.invalidate(withdrawalListProvider);
    ref.invalidate(savingsBalanceProvider);
    return response.data;
  }
}
