import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
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

  // 1. Busca os dados iniciais quando a tela é construída pela primeira vez.
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para garantir que o ref estará disponível.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final week = getWeekApiFormat(ref.read(currentDateProvider));
      ref.read(farmDrawingsProvider.notifier).fetchDrawings(week);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Ouve as mudanças na data para buscar novos dados quando a semana muda.
    ref.listen<DateTime>(currentDateProvider, (previous, next) {
      final week = getWeekApiFormat(next);
      // Evita buscar novamente se a semana for a mesma
      if (getWeekApiFormat(previous!) != week) {
        ref.read(farmDrawingsProvider.notifier).fetchDrawings(week);
      }
    });

    final screenMode = ref.watch(screenModeStateProvider);
    final drawingNotifier = ref.read(farmDrawingsProvider.notifier);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazenda do Murilo'),
        actions: [
          if (screenMode == ScreenMode.editing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              tooltip: 'Limpar desenho',
              // 3. Modifica o onPressed para chamar o novo método assíncrono.
              onPressed: () async {
                // Adiciona uma confirmação para o usuário
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('Deseja limpar o desenho para este problema nesta semana?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Limpar')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await drawingNotifier.clear();
                }
              },
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
            // 4. Modifica o onPressed para salvar antes de mudar de modo.
            onPressed: () async {
              print("CLicou botao");
              if (screenMode == ScreenMode.editing) {
                await drawingNotifier.saveDrawings();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Desenho salvo com sucesso!'), backgroundColor: Colors.green),
                );
              }
              // Só então troca o modo
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
              // 5. Usa um Stack para mostrar o indicador de carregamento sobre o mapa.
              child: Stack(
                children: [
                  Center(
                    child: FarmMapView(),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}