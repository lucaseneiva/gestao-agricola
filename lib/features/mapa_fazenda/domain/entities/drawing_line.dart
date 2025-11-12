import 'package:flutter/material.dart';

// Usaremos esta classe para representar um único traço contínuo
@immutable // Torna a classe imutável, boa prática para estado
class DrawingLine {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  const DrawingLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  // Um método 'copyWith' é super útil para atualizar o estado de forma imutável
  DrawingLine copyWith({List<Offset>? points}) {
    return DrawingLine(
      points: points ?? this.points,
      color: color,
      strokeWidth: strokeWidth,
    );
  }
}