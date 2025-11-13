import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';

//==============================================================================
// WIDGET PRINCIPAL DA VISUALIZAÇÃO DO MAPA
//==============================================================================
class FarmMapView extends ConsumerWidget {
  const FarmMapView({super.key});

  /// Função auxiliar para a lógica da borracha.
  /// Encontra e remove o traço que está sob a [position] do dedo.
  void _eraseAt(
    Offset position,
    List<List<Offset>> activeStrokes, // A borracha só afeta os traços ativos
    FarmDrawings notifier,
  ) {
    // Define o raio de alcance da borracha
    const eraserRadius = 20.0;

    // Cria uma cópia da lista de traços para iterar com segurança,
    // evitando erros de modificação concorrente.
    final strokesCopy = List<List<Offset>>.from(activeStrokes);

    for (final stroke in strokesCopy) {
      // Verifica se algum ponto ('point') dentro do traço ('stroke')
      // está dentro do raio da borracha.
      final isHit =
          stroke.any((point) => (point - position).distance < eraserRadius);

      if (isHit) {
        // Se encontrou um traço, chama o método para removê-lo do estado.
        notifier.removeStroke(stroke);
        // Interrompe o loop para apagar apenas um traço por vez, melhorando a performance.
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tamanho fixo da "prancheta" onde o SVG e os desenhos vivem.
    const Size artboardSize = Size(640, 1024);

    // Observa os providers necessários para o funcionamento da UI.
    final screenMode = ref.watch(screenModeStateProvider);
    final currentTool = ref.watch(currentToolProvider);
    final displayDrawings = ref.watch(displayDrawingsProvider);
    final drawingNotifier = ref.read(farmDrawingsProvider.notifier);

    return ClipRect(
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: artboardSize.width,
            height: artboardSize.height,
            child: Stack(
              children: [
                // Camada 1: O mapa da fazenda em SVG.
                SvgPicture.asset(
                  'assets/images/fazenda_murilo_p.svg',
                  width: artboardSize.width,
                  height: artboardSize.height,
                ),

                // Camada 2: A área de desenho interativa.
                IgnorePointer(
                  // Desabilita a interação se não estiver no modo de edição.
                  ignoring: screenMode == ScreenMode.viewing,
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (currentTool == DrawTool.pencil) {
                        drawingNotifier.startStroke(details.localPosition);
                      } else if (currentTool == DrawTool.eraser) {
                        _eraseAt(
                          details.localPosition,
                          displayDrawings.activeStrokes,
                          drawingNotifier,
                        );
                      }
                    },
                    onPanUpdate: (details) {
                      if (currentTool == DrawTool.pencil) {
                        drawingNotifier.addPoint(details.localPosition);
                      } else if (currentTool == DrawTool.eraser) {
                        _eraseAt(
                          details.localPosition,
                          displayDrawings.activeStrokes,
                          drawingNotifier,
                        );
                      }
                    },
                    child: CustomPaint(
                      // Passa as duas listas de desenhos para o pintor.
                      painter: DrawingPainter(
                        activeStrokes: displayDrawings.activeStrokes,
                        inactiveStrokes: displayDrawings.inactiveStrokes,
                      ),
                      size: artboardSize,
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

//==============================================================================
// PAINTER CUSTOMIZADO RESPONSÁVEL POR DESENHAR NA TELA
//==============================================================================
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> activeStrokes;
  final List<List<Offset>> inactiveStrokes;

  DrawingPainter({required this.activeStrokes, required this.inactiveStrokes});

  /// Desenha um conjunto de traços [strokes] no [canvas] com um [paint] específico.
  void _paintStrokes(Canvas canvas, List<List<Offset>> strokes, Paint paint) {
    for (final stroke in strokes) {
      // Um traço precisa de pelo menos 2 pontos para formar uma linha.
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
  void paint(Canvas canvas, Size size) {
    // Define o estilo do pincel para os desenhos ATIVOS (vermelho).
    final activePaint = Paint()
      ..color = const Color(0xFFD32F2F).withOpacity(0.7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    // Define o estilo do pincel para os desenhos INATIVOS (cinza).
    final inactivePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0 // Um pouco mais fino para dar menos destaque.
      ..style = PaintingStyle.stroke;

    // 1. Pinta os traços inativos primeiro para que fiquem no fundo.
    _paintStrokes(canvas, inactiveStrokes, inactivePaint);

    // 2. Pinta os traços ativos por cima.
    _paintStrokes(canvas, activeStrokes, activePaint);
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // O pintor deve redesenhar se qualquer uma das listas de traços for alterada.
    return oldDelegate.activeStrokes != activeStrokes ||
        oldDelegate.inactiveStrokes != inactiveStrokes;
  }
}