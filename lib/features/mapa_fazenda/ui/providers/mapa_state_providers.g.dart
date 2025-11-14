// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentTool)
const currentToolProvider = CurrentToolProvider._();

final class CurrentToolProvider
    extends $NotifierProvider<CurrentTool, DrawTool> {
  const CurrentToolProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentToolProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentToolHash();

  @$internal
  @override
  CurrentTool create() => CurrentTool();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrawTool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrawTool>(value),
    );
  }
}

String _$currentToolHash() => r'ddb6dec397753850961f06128364335d4ffeb84d';

abstract class _$CurrentTool extends $Notifier<DrawTool> {
  DrawTool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DrawTool, DrawTool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DrawTool, DrawTool>,
              DrawTool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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

@ProviderFor(FarmDrawings)
const farmDrawingsProvider = FarmDrawingsProvider._();

final class FarmDrawingsProvider
    extends $NotifierProvider<FarmDrawings, Map<String, Drawing>> {
  const FarmDrawingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'farmDrawingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$farmDrawingsHash();

  @$internal
  @override
  FarmDrawings create() => FarmDrawings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Drawing> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Drawing>>(value),
    );
  }
}

String _$farmDrawingsHash() => r'dfbdcd53c8d343b77c3a0156acfea9fe5a1a03cb';

abstract class _$FarmDrawings extends $Notifier<Map<String, Drawing>> {
  Map<String, Drawing> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, Drawing>, Map<String, Drawing>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Drawing>, Map<String, Drawing>>,
              Map<String, Drawing>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(displayDrawings)
const displayDrawingsProvider = DisplayDrawingsProvider._();

final class DisplayDrawingsProvider
    extends
        $FunctionalProvider<DisplayDrawings, DisplayDrawings, DisplayDrawings>
    with $Provider<DisplayDrawings> {
  const DisplayDrawingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayDrawingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayDrawingsHash();

  @$internal
  @override
  $ProviderElement<DisplayDrawings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DisplayDrawings create(Ref ref) {
    return displayDrawings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayDrawings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayDrawings>(value),
    );
  }
}

String _$displayDrawingsHash() => r'e90003b6e75ec3b211f702843c0a6333992bd8a4';

@ProviderFor(mapaRepository)
const mapaRepositoryProvider = MapaRepositoryProvider._();

final class MapaRepositoryProvider
    extends $FunctionalProvider<IMapRepository, IMapRepository, IMapRepository>
    with $Provider<IMapRepository> {
  const MapaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapaRepositoryHash();

  @$internal
  @override
  $ProviderElement<IMapRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IMapRepository create(Ref ref) {
    return mapaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMapRepository>(value),
    );
  }
}

String _$mapaRepositoryHash() => r'd8556cb2eda5ffd8e7def46c1767e73c419345e7';

@ProviderFor(IsLoading)
const isLoadingProvider = IsLoadingProvider._();

final class IsLoadingProvider extends $NotifierProvider<IsLoading, bool> {
  const IsLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoadingHash();

  @$internal
  @override
  IsLoading create() => IsLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoadingHash() => r'7ac3400b2b7645b8ecfda5ba1799b8a7e3123ffe';

abstract class _$IsLoading extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
