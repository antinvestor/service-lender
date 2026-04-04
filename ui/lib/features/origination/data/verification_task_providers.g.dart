// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VerificationTaskList)
final verificationTaskListProvider = VerificationTaskListFamily._();

final class VerificationTaskListProvider
    extends
        $AsyncNotifierProvider<
          VerificationTaskList,
          List<VerificationTaskObject>
        > {
  VerificationTaskListProvider._({
    required VerificationTaskListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'verificationTaskListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verificationTaskListHash();

  @override
  String toString() {
    return r'verificationTaskListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VerificationTaskList create() => VerificationTaskList();

  @override
  bool operator ==(Object other) {
    return other is VerificationTaskListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verificationTaskListHash() =>
    r'2328c743011ae4d8905659b8fe5c64065c34e65b';

final class VerificationTaskListFamily extends $Family
    with
        $ClassFamilyOverride<
          VerificationTaskList,
          AsyncValue<List<VerificationTaskObject>>,
          List<VerificationTaskObject>,
          FutureOr<List<VerificationTaskObject>>,
          String
        > {
  VerificationTaskListFamily._()
    : super(
        retry: null,
        name: r'verificationTaskListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VerificationTaskListProvider call(String applicationId) =>
      VerificationTaskListProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'verificationTaskListProvider';
}

abstract class _$VerificationTaskList
    extends $AsyncNotifier<List<VerificationTaskObject>> {
  late final _$args = ref.$arg as String;
  String get applicationId => _$args;

  FutureOr<List<VerificationTaskObject>> build(String applicationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<VerificationTaskObject>>,
              List<VerificationTaskObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<VerificationTaskObject>>,
                List<VerificationTaskObject>
              >,
              AsyncValue<List<VerificationTaskObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(VerificationTaskNotifier)
final verificationTaskProvider = VerificationTaskNotifierProvider._();

final class VerificationTaskNotifierProvider
    extends $AsyncNotifierProvider<VerificationTaskNotifier, void> {
  VerificationTaskNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verificationTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verificationTaskNotifierHash();

  @$internal
  @override
  VerificationTaskNotifier create() => VerificationTaskNotifier();
}

String _$verificationTaskNotifierHash() =>
    r'5530b27936e43c2aa7d4dffa026ae5e2e6739642';

abstract class _$VerificationTaskNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
