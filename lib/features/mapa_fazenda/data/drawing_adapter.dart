import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../ui/providers/mapa_state_providers.dart';

// Adapta (converte) os dados do desenho para um formato que pode ser salvo na API
class DrawingAdapter {
  static String toJson(Map<IssueType, List<List<Offset>>> issueDrawings) {
    final serializableMap = issueDrawings.map((key, strokes) {
      final serializableStrokes = strokes
          .map((stroke) =>
              stroke.map((point) => {'dx': point.dx, 'dy': point.dy}).toList())
          .toList();
      // A chave do mapa (enum) é convertida para string (ex: 'IssueType.pest')
      return MapEntry(key.toString(), serializableStrokes);
    });
    return jsonEncode(serializableMap);
  }

  /// Converte um JSON de volta para um mapa de desenhos (Praga/Doença).
  static Map<IssueType, List<List<Offset>>> fromMap(Map<String, dynamic> mapData) {
    if (mapData.isEmpty) {
      return {};
    }
    try {
      
      return mapData.map((key, value) {
        // Converte a string da chave de volta para o enum IssueType
        final issueType = IssueType.values.firstWhere((e) => e.toString() == key);
        
        // Converte a lista de pontos de volta para List<List<Offset>>
        final strokes = (value as List)
            .map<List<Offset>>((stroke) => (stroke as List)
                .map<Offset>((point) =>
                    Offset((point['dx'] as num).toDouble(), (point['dy'] as num).toDouble()))
                .toList())
            .toList();
            
        return MapEntry(issueType, strokes);
      });
    } catch (e) {
      if (kDebugMode) print('Erro ao decodificar os dados do desenho: $e');
      return {};
    }
  }
}