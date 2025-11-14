// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$farmDrawingsHash() => r'd22ef3c8ae8c9f906ca29b85833b5848791adf13';

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
