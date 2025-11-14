import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/map_repository.dart';
import '../../domain/entities/drawing.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/repositories/map_repository_interface.dart';

part 'mapa_state_providers.g.dart';

enum IssueType { pest, disease }

enum ScreenMode { viewing, editing }

enum DrawTool { pencil, eraser }

class DisplayDrawings {
  final List<Stroke> activeStrokes;
  final List<Stroke> inactiveStrokes;

  DisplayDrawings({required this.activeStrokes, required this.inactiveStrokes});
}

@riverpod
class CurrentTool extends _$CurrentTool {
  @override
  DrawTool build() => DrawTool.pencil;

  void setTool(DrawTool tool) => state = tool;
}

@riverpod
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void nextWeek() {
    state = state.add(const Duration(days: 7));
  }

  void previousWeek() {
    state = state.subtract(const Duration(days: 7));
  }
}

@riverpod
class SelectedIssue extends _$SelectedIssue {
  @override
  IssueType? build() {
    return IssueType.pest;
  }

  void setIssue(IssueType issue) {
    state = issue;
  }
}

@riverpod
class ScreenModeState extends _$ScreenModeState {
  @override
  ScreenMode build() {
    return ScreenMode.viewing;
  }

  void toggleMode() {
    state = state == ScreenMode.viewing
        ? ScreenMode.editing
        : ScreenMode.viewing;
  }
}

@riverpod
class FarmDrawings extends _$FarmDrawings {
  @override
  Map<String, Drawing> build() {
    return {};
  }

  // Limpa locamente os desenhos para a semana atual
  void clearAllForCurrentWeekLocally() {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    if (!state.containsKey(week)) return;

    state = {...state, week: state[week]!.copyWith(strokes: [])};
  }

  // Remove uma stroke específica localmente
  void removeStroke(Stroke strokeToRemove) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    if (!state.containsKey(week)) return;

    final currentDrawing = state[week]!;
    final newStrokes = List<Stroke>.from(currentDrawing.strokes)..remove(strokeToRemove);

    state = {...state, week: currentDrawing.copyWith(strokes: newStrokes)};
  }

  // Busca os desenhos para uma semana específica
  Future<void> fetchDrawings(String week) async {
    if (state.containsKey(week)) return;

    final repo = ref.read(mapaRepositoryProvider);
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final drawing = await repo.getDraw(week);
      state = {...state, week: drawing ?? Drawing(week: week)};
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar desenhos: $e");
      state = {...state, week: Drawing(week: week)}; // Garante que não ficará nulo
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // Salva os desenhos da semana atual na API
  Future<void> saveDrawings() async {
    final repo = ref.read(mapaRepositoryProvider);
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final drawingToSave = state[week];

    if (drawingToSave == null) return;

    ref.read(isLoadingProvider.notifier).state = true;
    try {
      await repo.saveDraw(drawingToSave);
    } catch (e) {
      if (kDebugMode) print("Erro ao salvar desenhos: $e");
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  
  void startStroke(Offset point) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    final currentDrawing = state[week] ?? Drawing(week: week);
    final newStroke = Stroke(issueType: issue, points: [point]);
    
    state = {
      ...state,
      week: currentDrawing.copyWith(
        strokes: [...currentDrawing.strokes, newStroke],
      ),
    };
  }

  void addPoint(Offset point) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final currentDrawing = state[week];
    if (currentDrawing == null || currentDrawing.strokes.isEmpty) return;

    final lastStroke = currentDrawing.strokes.last;
    final newPoints = [...lastStroke.points, point];
    final updatedStroke = Stroke(issueType: lastStroke.issueType, points: newPoints);

    final allButLast = currentDrawing.strokes.sublist(0, currentDrawing.strokes.length - 1);

    state = {
      ...state,
      week: currentDrawing.copyWith(
        strokes: [...allButLast, updatedStroke],
      ),
    };
  }
}

@riverpod
DisplayDrawings displayDrawings(Ref ref) {
  final allDrawings = ref.watch(farmDrawingsProvider);
  final week = getWeekApiFormat(ref.watch(currentDateProvider));
  final selectedIssue = ref.watch(selectedIssueProvider);

  if (selectedIssue == null) {
    return DisplayDrawings(activeStrokes: [], inactiveStrokes: []);
  }

  final weekDrawing = allDrawings[week];
  if (weekDrawing == null) {
    return DisplayDrawings(activeStrokes: [], inactiveStrokes: []);
  }

  final activeStrokes = weekDrawing.strokes.where((s) => s.issueType == selectedIssue).toList();
  final inactiveStrokes = weekDrawing.strokes.where((s) => s.issueType != selectedIssue).toList();

  return DisplayDrawings(
    activeStrokes: activeStrokes,
    inactiveStrokes: inactiveStrokes,
  );
}

@riverpod
IMapRepository mapaRepository(Ref ref) {
  return MapaRepository();
}

@riverpod
class IsLoading extends _$IsLoading {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}
