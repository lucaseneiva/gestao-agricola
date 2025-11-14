import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/map_repository.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/drawing_adapter.dart';

part 'mapa_state_providers.g.dart';

enum IssueType { pest, disease }

enum ScreenMode { viewing, editing }

enum DrawTool { pencil, eraser }

class DisplayDrawings {
  final List<List<Offset>> activeStrokes;
  final List<List<Offset>> inactiveStrokes;

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
  Map<String, Map<IssueType, List<List<Offset>>>> build() {
    return {};
  }

  // Limpa locamente os desenhos para a semana atual
  void clearAllForCurrentWeekLocally() {
    final week = getWeekApiFormat(ref.read(currentDateProvider));

    if (!state.containsKey(week) || state[week]!.isEmpty) return;

    state = {...state, week: {}};
  }

  // Remove uma stroke específica localmente
  void removeStroke(List<Offset> strokeToRemove) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    final currentStrokes = List<List<Offset>>.from(state[week]?[issue] ?? []);
    currentStrokes.remove(strokeToRemove);

    state = {
      ...state,
      week: {...(state[week] ?? {}), issue: currentStrokes},
    };
  }

  // Busca os desenhos para uma semana específica
  Future<void> fetchDrawings(String week) async {
    if (state.containsKey(week)) return;

    final repo = ref.read(mapaRepositoryProvider);
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final drawingsMap = await repo.getDraw(week);
      final drawings = DrawingAdapter.fromMap(drawingsMap ?? {});

      state = {...state, week: drawings};
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar desenhos: $e");
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // Salva os desenhos da semana atual na API
  Future<void> saveDrawings() async {
    final repo = ref.read(mapaRepositoryProvider);
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final drawingsForWeek = state[week] ?? {};

    ref.read(isLoadingProvider.notifier).state = true;
    try {
      final jsonString = DrawingAdapter.toJson(drawingsForWeek);
      await repo.saveDraw(week, jsonString);
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

    final currentDrawing = state[week]?[issue] ?? [];
    final newDrawing = [
      ...currentDrawing,
      [point],
    ];

    state = {
      ...state,
      week: {...(state[week] ?? {}), issue: newDrawing},
    };
  }

  void addPoint(Offset point) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);

    if (issue == null || state[week]?[issue] == null || state[week]![issue]!.isEmpty) return;

    final currentDrawing = state[week]?[issue] ?? [];
    final lastStroke = [...currentDrawing.last, point];
    final allButLast = currentDrawing.sublist(0, currentDrawing.length - 1);

    state = {
      ...state,
      week: {
        ...(state[week] ?? {}),
        issue: [...allButLast, lastStroke],
      },
    };
  }
}

@riverpod
DisplayDrawings displayDrawings(Ref ref) {
  // Observa o provider principal que contém TODOS os desenhos
  final allDrawings = ref.watch(farmDrawingsProvider);

  // Observa a data e o tipo de problema selecionado
  final week = getWeekApiFormat(ref.watch(currentDateProvider));
  final selectedIssue = ref.watch(selectedIssueProvider);

  // Se nenhum problema estiver selecionado, não mostra nada.
  if (selectedIssue == null) {
    return DisplayDrawings(activeStrokes: [], inactiveStrokes: []);
  }

  // Pega todos os desenhos da semana atual
  final weekDrawings = allDrawings[week] ?? {};

  // Define qual é o problema "inativo"
  final inactiveIssue = selectedIssue == IssueType.pest
      ? IssueType.disease
      : IssueType.pest;

  // Busca as listas de traços para cada um
  final activeStrokes = weekDrawings[selectedIssue] ?? [];
  final inactiveStrokes = weekDrawings[inactiveIssue] ?? [];

  // Retorna o objeto completo
  return DisplayDrawings(
    activeStrokes: activeStrokes,
    inactiveStrokes: inactiveStrokes,
  );
}

@riverpod
MapaRepository mapaRepository(Ref ref) {
  return MapaRepository();
}

@riverpod
class IsLoading extends _$IsLoading {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}
