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

String _$formTemplateListHash() => r'f65f8f1582a270462dbb582f5998c2f4fa79a3b4';

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
    r'17fb93b64ee804663a2330bbef47dc0b903517db';

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
    r'3e9dbe17c2f167982939d457517916f154d3a978';

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

/// Loads published form templates for a given entity type.
///
/// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
/// templates explicitly tagged for the requested domain. Admins set the
/// entity type when creating templates in the form template designer.

@ProviderFor(entityFormTemplates)
final entityFormTemplatesProvider = EntityFormTemplatesFamily._();

/// Loads published form templates for a given entity type.
///
/// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
/// templates explicitly tagged for the requested domain. Admins set the
/// entity type when creating templates in the form template designer.

final class EntityFormTemplatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FormTemplateObject>>,
          List<FormTemplateObject>,
          FutureOr<List<FormTemplateObject>>
        >
    with
        $FutureModifier<List<FormTemplateObject>>,
        $FutureProvider<List<FormTemplateObject>> {
  /// Loads published form templates for a given entity type.
  ///
  /// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
  /// templates explicitly tagged for the requested domain. Admins set the
  /// entity type when creating templates in the form template designer.
  EntityFormTemplatesProvider._({
    required EntityFormTemplatesFamily super.from,
    required ({FormEntityType entityType, String organizationId})
    super.argument,
  }) : super(
         retry: null,
         name: r'entityFormTemplatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$entityFormTemplatesHash();

  @override
  String toString() {
    return r'entityFormTemplatesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<FormTemplateObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FormTemplateObject>> create(Ref ref) {
    final argument =
        this.argument as ({FormEntityType entityType, String organizationId});
    return entityFormTemplates(
      ref,
      entityType: argument.entityType,
      organizationId: argument.organizationId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EntityFormTemplatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$entityFormTemplatesHash() =>
    r'91ff1e6eb0ec35b0d94eac06e0cb1fe5424d6ea7';

/// Loads published form templates for a given entity type.
///
/// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
/// templates explicitly tagged for the requested domain. Admins set the
/// entity type when creating templates in the form template designer.

final class EntityFormTemplatesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<FormTemplateObject>>,
          ({FormEntityType entityType, String organizationId})
        > {
  EntityFormTemplatesFamily._()
    : super(
        retry: null,
        name: r'entityFormTemplatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads published form templates for a given entity type.
  ///
  /// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
  /// templates explicitly tagged for the requested domain. Admins set the
  /// entity type when creating templates in the form template designer.

  EntityFormTemplatesProvider call({
    required FormEntityType entityType,
    String organizationId = '',
  }) => EntityFormTemplatesProvider._(
    argument: (entityType: entityType, organizationId: organizationId),
    from: this,
  );

  @override
  String toString() => r'entityFormTemplatesProvider';
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
    r'eb7828e11e60d7ec677d1208eb30d4c84064835f';

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

  FormSubmissionListProvider call({required String entityId}) =>
      FormSubmissionListProvider._(argument: entityId, from: this);

  @override
  String toString() => r'formSubmissionListProvider';
}

abstract class _$FormSubmissionList
    extends $AsyncNotifier<List<FormSubmissionObject>> {
  late final _$args = ref.$arg as String;
  String get entityId => _$args;

  FutureOr<List<FormSubmissionObject>> build({required String entityId});
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
    element.handleCreate(ref, () => build(entityId: _$args));
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
    r'ec047215b23922e5bae65546dae0616a597cf888';

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
