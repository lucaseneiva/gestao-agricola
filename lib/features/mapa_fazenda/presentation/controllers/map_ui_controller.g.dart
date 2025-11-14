// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_ui_controller.dart';

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

String _$screenModeStateHash() => r'931e787e8f48c3c25864b03b3cff966fd1bef756';

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

String _$selectedIssueHash() => r'a7b347925757fe5c6cbe873cbf2f78ed505778da';

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
