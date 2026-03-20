// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that builds an AuditContext from current JWT claims and device location.
/// The location is fetched in parallel with auth claims for speed.

@ProviderFor(auditContext)
final auditContextProvider = AuditContextProvider._();

/// Provider that builds an AuditContext from current JWT claims and device location.
/// The location is fetched in parallel with auth claims for speed.

final class AuditContextProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuditContext>,
          AuditContext,
          FutureOr<AuditContext>
        >
    with $FutureModifier<AuditContext>, $FutureProvider<AuditContext> {
  /// Provider that builds an AuditContext from current JWT claims and device location.
  /// The location is fetched in parallel with auth claims for speed.
  AuditContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditContextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditContextHash();

  @$internal
  @override
  $FutureProviderElement<AuditContext> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuditContext> create(Ref ref) {
    return auditContext(ref);
  }
}

String _$auditContextHash() => r'5b63f1011d7b5c57eee481f8f4c2d9d451d0e9e5';
