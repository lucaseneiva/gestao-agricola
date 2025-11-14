// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_selectors.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$displayDrawingsHash() => r'6762d83f1bc2d9c36590873de7b5717853ae12a5';
