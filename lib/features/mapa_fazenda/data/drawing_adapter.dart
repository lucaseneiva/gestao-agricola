import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../domain/entities/drawing.dart';
import '../domain/entities/stroke.dart';
import '../domain/types.dart';

class DrawingAdapter {
  static String toJson(Drawing drawing) {
    final Map<String, List<List<Map<String, double>>>> serializableMap = {};
    
    for (var stroke in drawing.strokes) {
      final key = stroke.issueType.toString();
      if (!serializableMap.containsKey(key)) {
        serializableMap[key] = [];
      }
      serializableMap[key]!.add(
        stroke.points.map((point) => {'dx': point.dx, 'dy': point.dy}).toList()
      );
    }
    return jsonEncode(serializableMap);
  }

  static Drawing fromMap(String week, Map<String, dynamic> mapData) {
    if (mapData.isEmpty) {
      return Drawing(week: week, strokes: []);
    }
    
    final List<Stroke> strokes = [];
    try {
      mapData.forEach((key, value) {
        final issueType = IssueType.values.firstWhere((e) => e.toString() == key);
        final List<List<Offset>> strokePoints = (value as List)
            .map<List<Offset>>((stroke) => (stroke as List)
                .map<Offset>((point) =>
                    Offset((point['dx'] as num).toDouble(), (point['dy'] as num).toDouble()))
                .toList())
            .toList();
        
        for (var points in strokePoints) {
          strokes.add(Stroke(issueType: issueType, points: points));
        }
      });
      return Drawing(week: week, strokes: strokes);
    } catch (e) {
      if (kDebugMode) print('Erro ao decodificar os dados do desenho: $e');
      return Drawing(week: week, strokes: []);
    }
  }
}