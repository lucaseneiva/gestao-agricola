import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen({super.key});

  @override
  ConsumerState<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  // 1. Defina um tamanho fixo para a sua "prancheta" de desenho.
  //    Isso deve ser idealmente a resolução nativa ou a proporção do seu SVG.
  //    Você pode ajustar esses valores para se adequar melhor ao seu arquivo.
  final Size _artboardSize = const Size(640, 1024);

  @override
  Widget build(BuildContext context) {
    final currentDate = ref.watch(currentDateProvider);
    final screenMode = ref.watch(screenModeStateProvider);
    final drawingPoints = ref.watch(drawingPointsProvider);
    final drawingNotifier = ref.read(drawingPointsProvider.notifier);

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
            _buildWeekSelector(context, ref, currentDate),
            const SizedBox(height: 16),
            _buildFilterButtons(context, ref),
            const SizedBox(height: 24),

            Expanded(
              child: Center(
                child: _buildMapView(
                  screenMode,
                  drawingPoints,
                  drawingNotifier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET DO MAPA TOTALMENTE REFEITO
  Widget _buildMapView(
    ScreenMode screenMode,
    List<List<Offset>> points,
    DrawingPoints drawingNotifier,
  ) {
    return ClipRect(
      child: InteractiveViewer(
        minScale: 1, // Permite diminuir o zoom
        maxScale: 4.0,
        // O filho do InteractiveViewer é a nossa prancheta escalonável
        child: FittedBox(
          fit: BoxFit.contain,
          // 2. A prancheta tem um tamanho fixo
          child: SizedBox(
            width: _artboardSize.width,
            height: _artboardSize.height,
            // 3. O Stack agora vive dentro da prancheta de tamanho fixo
            child: Stack(
              children: [
                // Camada 1: O SVG, que se expandirá para o tamanho da prancheta
                SvgPicture.asset(
                  'assets/images/fazenda_murilo_p.svg',
                  width: _artboardSize.width,
                  height: _artboardSize.height,
                ),

                // Camada 2: A área de desenho, que tem EXATAMENTE o mesmo tamanho do SVG
                IgnorePointer(
                  ignoring: screenMode == ScreenMode.viewing,
                  child: GestureDetector(
                    onPanStart: (details) {
                      // As coordenadas agora são relativas à prancheta de 1000x750
                      drawingNotifier.startStroke(details.localPosition);
                    },
                    onPanUpdate: (details) {
                      drawingNotifier.addPoint(details.localPosition);
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(strokes: points),
                      size:
                          _artboardSize, // Garante que o painter tenha o tamanho correto
                    ),
                  ),
                ),
              ],
            ),
          ),
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

// A CLASSE DO PAINTER NÃO PRECISA DE NENHUMA MUDANÇA
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;

  DrawingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD32F2F).withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length > 1) {
        final path = Path();
        path.moveTo(stroke.first.dx, stroke.first.dy);
        for (var i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}
