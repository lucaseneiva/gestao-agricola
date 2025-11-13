import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';

class FarmMapView extends ConsumerWidget {
  const FarmMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size artboardSize = const Size(640, 1024);
    final screenMode = ref.watch(screenModeStateProvider);
    final drawingPoints = ref.watch(currentDrawingProvider);
    final drawingNotifier = ref.read(farmDrawingsProvider.notifier);
    final currentTool = ref.watch(currentToolProvider);

    return ClipRect(
      child: InteractiveViewer(
        minScale: 1, // Permite diminuir o zoom
        maxScale: 4.0,
        // O filho do InteractiveViewer é a nossa prancheta escalonável
        child: FittedBox(
          fit: BoxFit.contain,
          // 2. A prancheta tem um tamanho fixo
          child: SizedBox(
            width: artboardSize.width,
            height: artboardSize.height,
            // 3. O Stack agora vive dentro da prancheta de tamanho fixo
            child: Stack(
              children: [
                // Camada 1: O SVG, que se expandirá para o tamanho da prancheta
                SvgPicture.asset(
                  'assets/images/fazenda_murilo_p.svg',
                  width: artboardSize.width,
                  height: artboardSize.height,
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
                      if (currentTool == DrawTool.pencil) {
                        drawingNotifier.addPoint(details.localPosition);
                      } else {
                        // LÓGICA DA BORRACHA
                        final eraserPosition = details.localPosition;
                        const eraserSize = 15.0; // Raio da borracha

                        // Faz uma cópia da lista para evitar erros de modificação durante a iteração
                        final strokesCopy = List<List<Offset>>.from(
                          drawingPoints,
                        );

                        for (final stroke in strokesCopy) {
                          // Verifica se algum ponto do traço está dentro do raio da borracha
                          final isTouching = stroke.any(
                            (point) =>
                                (point - eraserPosition).distance < eraserSize,
                          );

                          if (isTouching) {
                            drawingNotifier.removeStroke(stroke);
                            // O break é opcional, mas melhora a performance ao apagar um traço por vez
                            break;
                          }
                        }
                      }
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(strokes: drawingPoints),
                      size:
                          artboardSize, // Garante que o painter tenha o tamanho correto
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
}

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
