import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/widgets/map_screen_widgets.dart';

class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen({super.key});

  @override
  ConsumerState<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  @override
  Widget build(BuildContext context) {
    final screenMode = ref.watch(screenModeStateProvider);
    final drawingNotifier = ref.read(farmDrawingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazenda do Murilo'),
        actions: [
          if (screenMode == ScreenMode.editing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              tooltip: 'Limpar desenho',
              onPressed: drawingNotifier.clear,
            ),
          IconButton(
            icon: Icon(
              screenMode == ScreenMode.viewing
                  ? Icons.edit_outlined
                  : Icons.check,
              color: screenMode == ScreenMode.viewing
                  ? Colors.white
                  : Colors.lightGreenAccent,
            ),
            tooltip: screenMode == ScreenMode.viewing ? 'Editar' : 'Salvar',
            onPressed: () {
              ref.read(screenModeStateProvider.notifier).toggleMode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WeekSelector(),
            const SizedBox(height: 16),
            FilterButtons(),
            const SizedBox(height: 24),

            Expanded(
              child: Center(
                child: FarmMapView()
              ),
            ),
          ],
        ),
      ),
    );
  }

}
