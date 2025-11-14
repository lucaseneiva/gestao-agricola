import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/drawing.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/types.dart';
import 'date_controller.dart';
import 'map_ui_controller.dart';
import '../providers/map_repository_provider.dart';
part 'drawing_controller.g.dart';

@riverpod
class FarmDrawings extends _$FarmDrawings {
  @override
  Map<String, Drawing> build() => {};

  /// Lógica centralizada de busca
  Future<void> fetchDrawingsForCurrentWeek() async {
    final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
    
    if (state.containsKey(week)) return; // Cache simples

    ref.read(isLoadingProvider.notifier).setLoading(true);
    try {
      final repo = ref.read(mapRepositoryProvider); 
      final drawing = await repo.getDraw(week);
      state = {...state, week: drawing ?? Drawing(week: week)};
    } catch (e) {
      // Tratamento de erro
      state = {...state, week: Drawing(week: week)};
    } finally {
      ref.read(isLoadingProvider.notifier).setLoading(false);
    }
  }

  /// Lógica centralizada de salvar
  Future<void> saveCurrentWeek() async {
    final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
    final drawing = state[week];
    if (drawing == null) return;

    ref.read(isLoadingProvider.notifier).setLoading(true);
    try {
      await ref.read(mapRepositoryProvider).saveDraw(drawing);
    } finally {
      ref.read(isLoadingProvider.notifier).setLoading(false);
    }
  }

  // --- Lógica de Desenho (Movida da View para cá) ---

  void handlePanStart(Offset point) {
    final tool = ref.read(currentToolProvider);
    if (tool == DrawTool.pencil) {
      _startStroke(point);
    } else {
      _eraseAt(point);
    }
  }

  void handlePanUpdate(Offset point) {
    final tool = ref.read(currentToolProvider);
    if (tool == DrawTool.pencil) {
      _addPoint(point);
    } else {
      _eraseAt(point);
    }
  }

  void _startStroke(Offset point) {
    final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    final currentDrawing = state[week] ?? Drawing(week: week);
    final newStroke = Stroke(issueType: issue, points: [point]);
    
    _updateWeekDrawing(week, currentDrawing.copyWith(
      strokes: [...currentDrawing.strokes, newStroke],
    ));
  }

  void _addPoint(Offset point) {
    final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
    final currentDrawing = state[week];
    if (currentDrawing == null || currentDrawing.strokes.isEmpty) return;

    final lastStroke = currentDrawing.strokes.last;
    final newPoints = [...lastStroke.points, point];
    final updatedStroke = Stroke(issueType: lastStroke.issueType, points: newPoints);
    
    // Otimização: Substituir apenas o último stroke sem recriar toda a lista se possível
    // mas para imutabilidade padrão:
    final allButLast = currentDrawing.strokes.sublist(0, currentDrawing.strokes.length - 1);
    
    _updateWeekDrawing(week, currentDrawing.copyWith(
      strokes: [...allButLast, updatedStroke],
    ));
  }

  // Lógica de apagar movida da UI para o Controller
  void _eraseAt(Offset position) {
    final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
    final currentDrawing = state[week];
    if (currentDrawing == null) return;

    const eraserRadius = 20.0;
    // Filtrar: manter apenas strokes que NÃO colidem com a borracha
    final newStrokes = currentDrawing.strokes.where((stroke) {
      final isHit = stroke.points.any((point) => (point - position).distance < eraserRadius);
      return !isHit;
    }).toList();

    if (newStrokes.length != currentDrawing.strokes.length) {
       _updateWeekDrawing(week, currentDrawing.copyWith(strokes: newStrokes));
    }
  }
  
  void clearCurrentWeek() {
     final week = ref.read(currentDateProvider.notifier).formattedApiWeek;
     if(state.containsKey(week)) {
        _updateWeekDrawing(week, state[week]!.copyWith(strokes: []));
     }
  }

  void _updateWeekDrawing(String week, Drawing drawing) {
    state = {...state, week: drawing};
  }
}