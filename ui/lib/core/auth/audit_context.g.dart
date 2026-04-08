// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(auditContext)
final auditContextProvider = AuditContextProvider._();

final class AuditContextProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuditContext>,
          AuditContext,
          FutureOr<AuditContext>
        >
    with $FutureModifier<AuditContext>, $FutureProvider<AuditContext> {
  AuditContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditContextProvider',
        isAutoDispose: false,
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

String _$auditContextHash() => r'302427d60d4596f65d8a4f0b839fec118ec53276';
