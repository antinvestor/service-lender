library;

// Client wrappers
export 'src/client.dart';

// Identity service
export 'src/identity/v1/identity.pb.dart';
export 'src/identity/v1/identity.pbenum.dart';
export 'src/identity/v1/identity.pbjson.dart';
export 'src/identity/v1/identity.connect.client.dart';
export 'src/identity/v1/identity.connect.spec.dart';

// Field service
export 'src/field/v1/field.pb.dart';
export 'src/field/v1/field.pbenum.dart';
export 'src/field/v1/field.pbjson.dart';
export 'src/field/v1/field.connect.client.dart';
export 'src/field/v1/field.connect.spec.dart';

// Origination service
export 'src/origination/v1/origination.pb.dart';
export 'src/origination/v1/origination.pbenum.dart';
export 'src/origination/v1/origination.pbjson.dart';
export 'src/origination/v1/origination.connect.client.dart';
export 'src/origination/v1/origination.connect.spec.dart';

// Loan management service
export 'src/loans/v1/loans.pb.dart' hide InterestMethod, RepaymentFrequency;
export 'src/loans/v1/loans.pbenum.dart' hide InterestMethod, RepaymentFrequency;
export 'src/loans/v1/loans.pbjson.dart' hide InterestMethod$json, RepaymentFrequency$json, interestMethodDescriptor, repaymentFrequencyDescriptor;
export 'src/loans/v1/loans.connect.client.dart';
export 'src/loans/v1/loans.connect.spec.dart';

// Savings service
export 'src/savings/v1/savings.pb.dart';
export 'src/savings/v1/savings.pbenum.dart';
export 'src/savings/v1/savings.pbjson.dart';
export 'src/savings/v1/savings.connect.client.dart';
export 'src/savings/v1/savings.connect.spec.dart';

// Funding service
export 'src/funding/v1/funding.pb.dart';
export 'src/funding/v1/funding.pbenum.dart';
export 'src/funding/v1/funding.pbjson.dart';
export 'src/funding/v1/funding.connect.client.dart';
export 'src/funding/v1/funding.connect.spec.dart';

// Operations service
export 'src/operations/v1/operations.pb.dart';
export 'src/operations/v1/operations.pbenum.dart';
export 'src/operations/v1/operations.pbjson.dart';
export 'src/operations/v1/operations.connect.client.dart';
export 'src/operations/v1/operations.connect.spec.dart';

// Google type - Money
export 'src/google/type/money.pb.dart';
