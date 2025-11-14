import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/drawing_controller.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/domain/entities/stroke.dart';
import '../controllers/map_ui_controller.dart';
import '../providers/map_selectors.dart';
import '../../domain/types.dart';

class FarmMapView extends ConsumerWidget {
  const FarmMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Size artboardSize = Size(640, 1024);

    final screenMode = ref.watch(screenModeStateProvider);
    final displayDrawings = ref.watch(displayDrawingsProvider);
    
    final controller = ref.read(farmDrawingsProvider.notifier);
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
                  ignoring: screenMode == ScreenMode.viewing,
                  child: GestureDetector(
                    onPanStart: (d) =>
                        controller.handlePanStart(d.localPosition),
                    onPanUpdate: (d) =>
                        controller.handlePanUpdate(d.localPosition),
                    child: CustomPaint(
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

class DrawingPainter extends CustomPainter {
  final List<Stroke> activeStrokes;
  final List<Stroke> inactiveStrokes;

  DrawingPainter({required this.activeStrokes, required this.inactiveStrokes});

  void _paintStrokes(Canvas canvas, List<Stroke> strokes, Paint paint) {
    for (final stroke in strokes) {
      if (stroke.points.length > 1) {
        final path = Path();
        path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (var i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()
      ..color = const Color(0xFFD32F2F).withAlpha(178)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    final inactivePaint = Paint()
      ..color = Colors.grey.withAlpha(127)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    _paintStrokes(canvas, inactiveStrokes, inactivePaint);
    _paintStrokes(canvas, activeStrokes, activePaint);
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // O pintor deve redesenhar se qualquer uma das listas de traços for alterada.
    return oldDelegate.activeStrokes != activeStrokes ||
        oldDelegate.inactiveStrokes != inactiveStrokes;
  }
}
