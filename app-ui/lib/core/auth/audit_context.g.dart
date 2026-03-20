// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that builds an AuditContext from current JWT claims.

@ProviderFor(auditContext)
final auditContextProvider = AuditContextProvider._();

/// Provider that builds an AuditContext from current JWT claims.

final class AuditContextProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuditContext>,
          AuditContext,
          FutureOr<AuditContext>
        >
    with $FutureModifier<AuditContext>, $FutureProvider<AuditContext> {
  /// Provider that builds an AuditContext from current JWT claims.
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

String _$auditContextHash() => r'538036af0c21c93cc80b549d60fb6dbf0143181b';
