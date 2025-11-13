import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';

import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/map_repository.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/data/drawing_adapter.dart';

part 'mapa_state_providers.g.dart';

enum IssueType { pest, disease }
enum ScreenMode { viewing, editing }


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
    state = state == ScreenMode.viewing ? ScreenMode.editing : ScreenMode.viewing;
  }
}

@riverpod
class FarmDrawings extends _$FarmDrawings {
  @override
  Map<String, Map<IssueType, List<List<Offset>>>> build() {
    return {};
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
      state = { ...state, week: drawings };

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
      state = { ...state, week: weekData };

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
    final newDrawing = [...currentDrawing, [point]];
    
    state = {
      ...state,
      week: {
        ...(state[week] ?? {}),
        issue: newDrawing,
      }
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
      }
    };
  }
}

@riverpod
List<List<Offset>> currentDrawing(Ref ref) {
  // 1. Observa o provider principal que contém todos os desenhos
  final allDrawings = ref.watch(farmDrawingsProvider);
  
  // 2. Observa a data e o tipo de problema para saber "qual" desenho pegar
  final week = getWeekApiFormat(ref.watch(currentDateProvider));
  final issue = ref.watch(selectedIssueProvider);

  if (issue == null) {
    return []; // Retorna uma lista vazia se nenhum problema estiver selecionado
  }

  // 3. Retorna a lista de desenhos específica ou uma lista vazia se não houver nada
  return allDrawings[week]?[issue] ?? [];
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