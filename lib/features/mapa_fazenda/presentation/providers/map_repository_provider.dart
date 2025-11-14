import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/map_repository_interface.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/map_repository.dart';

part 'map_repository_provider.g.dart';

/// Provider que expõe a implementação do repositório do mapa.
@riverpod
IMapRepository mapRepository(Ref ref) {
  return MapaRepository();
}