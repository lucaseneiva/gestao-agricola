import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/widgets/drawing_painter.dart';

class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen({super.key});

  @override
  ConsumerState<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  final GlobalKey _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentDate = ref.watch(currentDateProvider);
    final screenMode = ref.watch(screenModeStateProvider);
    final lines = ref.watch(drawingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazenda do Murilo 🍓'),
        actions: [
          IconButton(
            icon: Icon(
              screenMode == ScreenMode.viewing
                  ? Icons.edit_outlined
                  : Icons.check,
              color: screenMode == ScreenMode.viewing
                  ? Colors.white
                  : Colors.lightGreenAccent,
            ),
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
            _buildWeekSelector(context, ref, currentDate),
            const SizedBox(height: 16),
            _buildFilterButtons(context, ref),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // SOLUÇÃO SIMPLES: Stack FORA do InteractiveViewer
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // CAMADA 1: Mapa SEM desenhos (pode dar zoom/pan)
                    IgnorePointer(
                      ignoring: screenMode == ScreenMode.editing,
                      child: SvgPicture.asset(
                        'assets/images/fazenda_murilo.svg',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // CAMADA 2: Desenho COM interação (modo edição)
                    if (screenMode == ScreenMode.editing)
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              key: _mapKey,
                              onPanStart: (details) {
                                // NORMALIZA: converte pixels para 0.0-1.0
                                final normalized = Offset(
                                  details.localPosition.dx / constraints.maxWidth,
                                  details.localPosition.dy / constraints.maxHeight,
                                );
                                print("🎨 Normalized: $normalized");
                                ref.read(drawingStateProvider.notifier).startLine(
                                      normalized,
                                      Colors.red.withOpacity(0.7),
                                      8.0,
                                    );
                              },
                              onPanUpdate: (details) {
                                // NORMALIZA: converte pixels para 0.0-1.0
                                final normalized = Offset(
                                  details.localPosition.dx / constraints.maxWidth,
                                  details.localPosition.dy / constraints.maxHeight,
                                );
                                ref
                                    .read(drawingStateProvider.notifier)
                                    .addPoint(normalized);
                              },
                              child: Container(
                                color: Colors.blue.withOpacity(0.1),
                                child: CustomPaint(
                                  painter: DrawingPainter(lines: lines),
                                  child: Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // CAMADA 3: Desenho APENAS visualização (modo viewing)
                    if (screenMode == ScreenMode.viewing)
                      IgnorePointer(
                        child: CustomPaint(
                          painter: DrawingPainter(lines: lines),
                          size: Size.infinite,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector(
    BuildContext context,
    WidgetRef ref,
    DateTime currentDate,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            ref.read(currentDateProvider.notifier).previousWeek();
          },
        ),
        Text(
          getWeekDisplayFormat(currentDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            ref.read(currentDateProvider.notifier).nextWeek();
          },
        ),
      ],
    );
  }

  Widget _buildFilterButtons(BuildContext context, WidgetRef ref) {
    final selectedIssue = ref.watch(selectedIssueProvider);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Pragas'),
            onPressed: () {
              ref.read(selectedIssueProvider.notifier).setIssue(IssueType.pest);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIssue == IssueType.pest
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.sick),
            label: const Text('Doenças'),
            onPressed: () {
              ref
                  .read(selectedIssueProvider.notifier)
                  .setIssue(IssueType.disease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIssue == IssueType.disease
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}