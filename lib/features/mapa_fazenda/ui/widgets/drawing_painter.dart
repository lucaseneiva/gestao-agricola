import 'package:desafio_tecnico_arauc/features/mapa_fazenda/domain/entities/drawing_line.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Para PointMode.polygon

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> lines;

  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    // Itera sobre cada linha que temos no nosso estado
    for (var line in lines) {
      // Configura o pincel (Paint) com as propriedades da linha
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round // Deixa as pontas das linhas arredondadas
        ..style = PaintingStyle.stroke;

      // Se a linha tem mais de um ponto, desenha!
      if (line.points.length > 1) {
        // O canvas.drawPoints desenha uma linha conectando todos os pontos
        canvas.drawPoints(PointMode.polygon, line.points, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // Redesenha a tela apenas se a lista de linhas for diferente
    return oldDelegate.lines != lines;
  }
}