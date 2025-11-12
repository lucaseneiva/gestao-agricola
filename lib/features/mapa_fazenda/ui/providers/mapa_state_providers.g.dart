// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentDate)
const currentDateProvider = CurrentDateProvider._();

final class CurrentDateProvider
    extends $NotifierProvider<CurrentDate, DateTime> {
  const CurrentDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDateHash();

  @$internal
  @override
  CurrentDate create() => CurrentDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentDateHash() => r'27ccb30602bb6640115e41cb4878a902913bd34a';

abstract class _$CurrentDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedIssue)
const selectedIssueProvider = SelectedIssueProvider._();

final class SelectedIssueProvider
    extends $NotifierProvider<SelectedIssue, IssueType?> {
  const SelectedIssueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedIssueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedIssueHash();

  @$internal
  @override
  SelectedIssue create() => SelectedIssue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IssueType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IssueType?>(value),
    );
  }
}

String _$selectedIssueHash() => r'0ce52ea78e4807d526eff8cd61b66a45f0bdb93f';

abstract class _$SelectedIssue extends $Notifier<IssueType?> {
  IssueType? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IssueType?, IssueType?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IssueType?, IssueType?>,
              IssueType?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ScreenModeState)
const screenModeStateProvider = ScreenModeStateProvider._();

final class ScreenModeStateProvider
    extends $NotifierProvider<ScreenModeState, ScreenMode> {
  const ScreenModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenModeStateHash();

  @$internal
  @override
  ScreenModeState create() => ScreenModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenMode>(value),
    );
  }
}

String _$screenModeStateHash() => r'1084a91b637134d104c250665bb4b5249277abb0';

abstract class _$ScreenModeState extends $Notifier<ScreenMode> {
  ScreenMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ScreenMode, ScreenMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScreenMode, ScreenMode>,
              ScreenMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DrawingPoints)
const drawingPointsProvider = DrawingPointsProvider._();

final class DrawingPointsProvider
    extends $NotifierProvider<DrawingPoints, List<List<Offset>>> {
  const DrawingPointsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drawingPointsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drawingPointsHash();

  @$internal
  @override
  DrawingPoints create() => DrawingPoints();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<Offset>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<Offset>>>(value),
    );
  }
}

String _$drawingPointsHash() => r'8b7651de51d0c43e9f7e1fce27b2ec40741d2a38';

abstract class _$DrawingPoints extends $Notifier<List<List<Offset>>> {
  List<List<Offset>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<List<Offset>>, List<List<Offset>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<List<Offset>>, List<List<Offset>>>,
              List<List<Offset>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
