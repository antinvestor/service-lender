//
//  Generated code. Do not modify.
//  source: funding/v1/funding.proto
//

import "package:connectrpc/connect.dart" as connect;
import "funding.pb.dart" as fundingv1funding;
import "funding.connect.spec.dart" as specs;

extension type FundingServiceClient (connect.Transport _transport) {
  Future<fundingv1funding.InvestorAccountSaveResponse> investorAccountSave(
    fundingv1funding.InvestorAccountSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.investorAccountSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<fundingv1funding.InvestorAccountGetResponse> investorAccountGet(
    fundingv1funding.InvestorAccountGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.investorAccountGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<fundingv1funding.InvestorAccountSearchResponse> investorAccountSearch(
    fundingv1funding.InvestorAccountSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FundingService.investorAccountSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<fundingv1funding.InvestorDepositResponse> investorDeposit(
    fundingv1funding.InvestorDepositRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.investorDeposit,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<fundingv1funding.InvestorWithdrawResponse> investorWithdraw(
    fundingv1funding.InvestorWithdrawRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.investorWithdraw,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<fundingv1funding.FundLoanResponse> fundLoan(
    fundingv1funding.FundLoanRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.fundLoan,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<fundingv1funding.AbsorbLossResponse> absorbLoss(
    fundingv1funding.AbsorbLossRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FundingService.absorbLoss,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
