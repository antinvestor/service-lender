// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(internalTeamList)
final internalTeamListProvider = InternalTeamListFamily._();

final class InternalTeamListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InternalTeamObject>>,
          List<InternalTeamObject>,
          FutureOr<List<InternalTeamObject>>
        >
    with
        $FutureModifier<List<InternalTeamObject>>,
        $FutureProvider<List<InternalTeamObject>> {
  InternalTeamListProvider._({
    required InternalTeamListFamily super.from,
    required ({String query, String organizationId}) super.argument,
  }) : super(
         retry: null,
         name: r'internalTeamListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$internalTeamListHash();

  @override
  String toString() {
    return r'internalTeamListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<InternalTeamObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InternalTeamObject>> create(Ref ref) {
    final argument = this.argument as ({String query, String organizationId});
    return internalTeamList(
      ref,
      query: argument.query,
      organizationId: argument.organizationId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InternalTeamListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$internalTeamListHash() => r'b481b3577999b2814adedac6ba7b9effb8daeca0';

final class InternalTeamListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<InternalTeamObject>>,
          ({String query, String organizationId})
        > {
  InternalTeamListFamily._()
    : super(
        retry: null,
        name: r'internalTeamListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InternalTeamListProvider call({
    required String query,
    String organizationId = '',
  }) => InternalTeamListProvider._(
    argument: (query: query, organizationId: organizationId),
    from: this,
  );

  @override
  String toString() => r'internalTeamListProvider';
}

@ProviderFor(InternalTeamNotifier)
final internalTeamProvider = InternalTeamNotifierProvider._();

final class InternalTeamNotifierProvider
    extends $AsyncNotifierProvider<InternalTeamNotifier, void> {
  InternalTeamNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internalTeamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internalTeamNotifierHash();

  @$internal
  @override
  InternalTeamNotifier create() => InternalTeamNotifier();
}

String _$internalTeamNotifierHash() =>
    r'7e91ec71b6601ebbc681760933603275f582ba39';

abstract class _$InternalTeamNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(teamMembershipList)
final teamMembershipListProvider = TeamMembershipListFamily._();

final class TeamMembershipListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TeamMembershipObject>>,
          List<TeamMembershipObject>,
          FutureOr<List<TeamMembershipObject>>
        >
    with
        $FutureModifier<List<TeamMembershipObject>>,
        $FutureProvider<List<TeamMembershipObject>> {
  TeamMembershipListProvider._({
    required TeamMembershipListFamily super.from,
    required ({String teamId, String memberId}) super.argument,
  }) : super(
         retry: null,
         name: r'teamMembershipListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teamMembershipListHash();

  @override
  String toString() {
    return r'teamMembershipListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TeamMembershipObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TeamMembershipObject>> create(Ref ref) {
    final argument = this.argument as ({String teamId, String memberId});
    return teamMembershipList(
      ref,
      teamId: argument.teamId,
      memberId: argument.memberId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TeamMembershipListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teamMembershipListHash() =>
    r'3f6ccfa8aa69df087c7273a8fcdd1bf16ef3573f';

final class TeamMembershipListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TeamMembershipObject>>,
          ({String teamId, String memberId})
        > {
  TeamMembershipListFamily._()
    : super(
        retry: null,
        name: r'teamMembershipListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TeamMembershipListProvider call({
    required String teamId,
    String memberId = '',
  }) => TeamMembershipListProvider._(
    argument: (teamId: teamId, memberId: memberId),
    from: this,
  );

  @override
  String toString() => r'teamMembershipListProvider';
}

@ProviderFor(TeamMembershipNotifier)
final teamMembershipProvider = TeamMembershipNotifierProvider._();

final class TeamMembershipNotifierProvider
    extends $AsyncNotifierProvider<TeamMembershipNotifier, void> {
  TeamMembershipNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamMembershipProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamMembershipNotifierHash();

  @$internal
  @override
  TeamMembershipNotifier create() => TeamMembershipNotifier();
}

String _$teamMembershipNotifierHash() =>
    r'3602be6c637307363447a9cba83bc7043e67244b';

abstract class _$TeamMembershipNotifier extends $AsyncNotifier<void> {
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
