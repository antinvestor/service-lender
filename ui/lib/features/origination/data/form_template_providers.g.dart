// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_template_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormTemplateList)
final formTemplateListProvider = FormTemplateListFamily._();

final class FormTemplateListProvider
    extends $AsyncNotifierProvider<FormTemplateList, List<FormTemplateObject>> {
  FormTemplateListProvider._({
    required FormTemplateListFamily super.from,
    required (String, {String organizationId}) super.argument,
  }) : super(
         retry: null,
         name: r'formTemplateListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formTemplateListHash();

  @override
  String toString() {
    return r'formTemplateListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FormTemplateList create() => FormTemplateList();

  @override
  bool operator ==(Object other) {
    return other is FormTemplateListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formTemplateListHash() => r'028abb32c12bf2036c688d20e8363410a81de77f';

final class FormTemplateListFamily extends $Family
    with
        $ClassFamilyOverride<
          FormTemplateList,
          AsyncValue<List<FormTemplateObject>>,
          List<FormTemplateObject>,
          FutureOr<List<FormTemplateObject>>,
          (String, {String organizationId})
        > {
  FormTemplateListFamily._()
    : super(
        retry: null,
        name: r'formTemplateListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormTemplateListProvider call(String query, {String organizationId = ''}) =>
      FormTemplateListProvider._(
        argument: (query, organizationId: organizationId),
        from: this,
      );

  @override
  String toString() => r'formTemplateListProvider';
}

abstract class _$FormTemplateList
    extends $AsyncNotifier<List<FormTemplateObject>> {
  late final _$args = ref.$arg as (String, {String organizationId});
  String get query => _$args.$1;
  String get organizationId => _$args.organizationId;

  FutureOr<List<FormTemplateObject>> build(
    String query, {
    String organizationId = '',
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<FormTemplateObject>>,
              List<FormTemplateObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FormTemplateObject>>,
                List<FormTemplateObject>
              >,
              AsyncValue<List<FormTemplateObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, organizationId: _$args.organizationId),
    );
  }
}

@ProviderFor(FormTemplateDetail)
final formTemplateDetailProvider = FormTemplateDetailFamily._();

final class FormTemplateDetailProvider
    extends $AsyncNotifierProvider<FormTemplateDetail, FormTemplateObject> {
  FormTemplateDetailProvider._({
    required FormTemplateDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'formTemplateDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formTemplateDetailHash();

  @override
  String toString() {
    return r'formTemplateDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FormTemplateDetail create() => FormTemplateDetail();

  @override
  bool operator ==(Object other) {
    return other is FormTemplateDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formTemplateDetailHash() =>
    r'ec1c2f25f312fdad3dc39cd84a2c24f8883dcb96';

final class FormTemplateDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          FormTemplateDetail,
          AsyncValue<FormTemplateObject>,
          FormTemplateObject,
          FutureOr<FormTemplateObject>,
          String
        > {
  FormTemplateDetailFamily._()
    : super(
        retry: null,
        name: r'formTemplateDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormTemplateDetailProvider call(String id) =>
      FormTemplateDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'formTemplateDetailProvider';
}

abstract class _$FormTemplateDetail extends $AsyncNotifier<FormTemplateObject> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<FormTemplateObject> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FormTemplateObject>, FormTemplateObject>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FormTemplateObject>, FormTemplateObject>,
              AsyncValue<FormTemplateObject>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(FormTemplateNotifier)
final formTemplateProvider = FormTemplateNotifierProvider._();

final class FormTemplateNotifierProvider
    extends $AsyncNotifierProvider<FormTemplateNotifier, void> {
  FormTemplateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formTemplateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formTemplateNotifierHash();

  @$internal
  @override
  FormTemplateNotifier create() => FormTemplateNotifier();
}

String _$formTemplateNotifierHash() =>
    r'a35246ae45de9742f60c3e03f8febdd813496d61';

abstract class _$FormTemplateNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(FormSubmissionList)
final formSubmissionListProvider = FormSubmissionListFamily._();

final class FormSubmissionListProvider
    extends
        $AsyncNotifierProvider<FormSubmissionList, List<FormSubmissionObject>> {
  FormSubmissionListProvider._({
    required FormSubmissionListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'formSubmissionListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$formSubmissionListHash();

  @override
  String toString() {
    return r'formSubmissionListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FormSubmissionList create() => FormSubmissionList();

  @override
  bool operator ==(Object other) {
    return other is FormSubmissionListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$formSubmissionListHash() =>
    r'362df6900009763df3bd51473594321c2dfd40d0';

final class FormSubmissionListFamily extends $Family
    with
        $ClassFamilyOverride<
          FormSubmissionList,
          AsyncValue<List<FormSubmissionObject>>,
          List<FormSubmissionObject>,
          FutureOr<List<FormSubmissionObject>>,
          String
        > {
  FormSubmissionListFamily._()
    : super(
        retry: null,
        name: r'formSubmissionListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FormSubmissionListProvider call({required String applicationId}) =>
      FormSubmissionListProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'formSubmissionListProvider';
}

abstract class _$FormSubmissionList
    extends $AsyncNotifier<List<FormSubmissionObject>> {
  late final _$args = ref.$arg as String;
  String get applicationId => _$args;

  FutureOr<List<FormSubmissionObject>> build({required String applicationId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<FormSubmissionObject>>,
              List<FormSubmissionObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FormSubmissionObject>>,
                List<FormSubmissionObject>
              >,
              AsyncValue<List<FormSubmissionObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(applicationId: _$args));
  }
}

@ProviderFor(FormSubmissionNotifier)
final formSubmissionProvider = FormSubmissionNotifierProvider._();

final class FormSubmissionNotifierProvider
    extends $AsyncNotifierProvider<FormSubmissionNotifier, void> {
  FormSubmissionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formSubmissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formSubmissionNotifierHash();

  @$internal
  @override
  FormSubmissionNotifier create() => FormSubmissionNotifier();
}

String _$formSubmissionNotifierHash() =>
    r'e6d624e6e0cc54d82deddeb4a1706f17b5cfd70b';

abstract class _$FormSubmissionNotifier extends $AsyncNotifier<void> {
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
