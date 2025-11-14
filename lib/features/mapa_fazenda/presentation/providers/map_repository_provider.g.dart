// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider que expõe a implementação do repositório do mapa.

@ProviderFor(mapRepository)
const mapRepositoryProvider = MapRepositoryProvider._();

/// Provider que expõe a implementação do repositório do mapa.

final class MapRepositoryProvider
    extends $FunctionalProvider<IMapRepository, IMapRepository, IMapRepository>
    with $Provider<IMapRepository> {
  /// Provider que expõe a implementação do repositório do mapa.
  const MapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRepositoryHash();

  @$internal
  @override
  $ProviderElement<IMapRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IMapRepository create(Ref ref) {
    return mapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMapRepository>(value),
    );
  }
}

String _$mapRepositoryHash() => r'd9ac187a22c1cf11b1ade6e8f01a9db0c058b051';
