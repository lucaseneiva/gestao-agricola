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

  DisplayDrawings({
    required this.activeStrokes,
    required this.inactiveStrokes,
  });
}

@riverpod
class CurrentTool extends _$CurrentTool {
  @override
  DrawTool build() => DrawTool.pencil;

  void setTool(DrawTool tool) => state = tool;
}

@riverpod
// 3. Criamos uma classe Notifier
class CurrentDate extends _$CurrentDate {
  // 4. O método build define o estado inicial
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

  void clearAllForCurrentWeekLocally() {
    final week = getWeekApiFormat(ref.read(currentDateProvider));

    // Se não há nada para limpar, não faz nada.
    if (!state.containsKey(week) || state[week]!.isEmpty) return;
    
    // Atualiza o estado local, substituindo os dados da semana por um mapa vazio.
    // Isso apaga pragas e doenças da memória do app para esta semana.
    state = {
      ...state,
      week: {}, 
    };
    
    // Nenhuma chamada à API aqui. A limpeza só será persistida
    // quando o usuário clicar no botão "Salvar".
}

  void removeStroke(List<Offset> strokeToRemove) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    final currentStrokes = List<List<Offset>>.from(state[week]?[issue] ?? []);
    currentStrokes.remove(strokeToRemove); // Remove o traço da lista

    state = {
      ...state,
      week: {...(state[week] ?? {}), issue: currentStrokes},
    };
  }

  // NOVO MÉTODO: Busca os desenhos para uma semana específica
  Future<void> fetchDrawings(String week) async {
    // Se já temos os dados para essa semana, não busca de novo.
    if (state.containsKey(week)) return;

    final repo = ref.read(mapaRepositoryProvider);
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final jsonString = await repo.getDraw(week);
      final drawings = DrawingAdapter.fromJson(jsonString);

      // Atualiza o estado com os dados da semana buscada
      state = {...state, week: drawings};
    } catch (e) {
      // Aqui você poderia lidar com o erro, por exemplo, mostrando uma SnackBar
      print("Erro ao buscar desenhos: $e");
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // NOVO MÉTODO: Salva os desenhos da semana atual na API
  Future<void> saveDrawings() async {
    print("Entrou no provider");
    final repo = ref.read(mapaRepositoryProvider);
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final drawingsForWeek = state[week] ?? {};

    ref.read(isLoadingProvider.notifier).state = true;
    try {
      final jsonString = DrawingAdapter.toJson(drawingsForWeek);
      await repo.saveDraw(week, jsonString);
      // Opcional: mostrar um feedback de sucesso (SnackBar)
    } catch (e) {
      print("Erro ao salvar desenhos: $e");
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // MÉTODO MODIFICADO: Limpa o desenho local E o remoto
  Future<void> clear() async {
    final repo = ref.read(mapaRepositoryProvider);
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    ref.read(isLoadingProvider.notifier).state = true;
    try {
      // Atualiza o estado local
      final weekData = state[week] ?? {};
      weekData[issue] = [];
      state = {...state, week: weekData};

      // Salva o estado atualizado (com o item limpo) na API
      await saveDrawings();
      // Nota: Uma abordagem alternativa seria chamar repo.deleteDraw(week),
      // mas isso apagaria pragas E doenças. Salvar o estado atualizado é mais seguro.
    } catch (e) {
      print("Erro ao limpar desenho: $e");
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  // Os métodos startStroke e addPoint continuam os mesmos
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
    if (issue == null ||
        state[week]?[issue] == null ||
        state[week]![issue]!.isEmpty)
      return;

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
