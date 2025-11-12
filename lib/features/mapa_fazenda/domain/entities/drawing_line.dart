import 'package:flutter/material.dart';

class DrawingLine {
  final List<Offset> points; // Estes serão valores de 0.0 a 1.0
  final Color color;
  final double strokeWidth;
  
  const DrawingLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  DrawingLine copyWith({
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
  }) {
    return DrawingLine(
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
