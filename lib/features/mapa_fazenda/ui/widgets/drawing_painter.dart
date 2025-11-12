import 'package:desafio_tecnico_arauc/features/mapa_fazenda/domain/entities/drawing_line.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> lines;
  
  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    print("🎨 DrawingPainter: ${lines.length} linhas, Size: $size");
    
    for (final line in lines) {
      if (line.points.isEmpty) continue;
      
      print("  📍 Linha com ${line.points.length} pontos");

      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // COORDENADAS NORMALIZADAS (0.0 a 1.0) convertidas para pixels
      final Path path = Path();
      final firstPoint = Offset(
        line.points.first.dx * size.width,
        line.points.first.dy * size.height,
      );
      path.moveTo(firstPoint.dx, firstPoint.dy);

      for (int i = 1; i < line.points.length; i++) {
        final point = Offset(
          line.points[i].dx * size.width,
          line.points[i].dy * size.height,
        );
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.lines != lines;
  }
}