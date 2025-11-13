import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';

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
  // O estado será um mapa complexo para armazenar todos os desenhos
  @override
  Map<String, Map<IssueType, List<List<Offset>>>> build() {
    // No futuro, aqui você poderia carregar os dados de um banco de dados ou API
    return {};
  }


  // Inicia um novo traço
  void startStroke(Offset point) {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    final currentDrawing = state[week]?[issue] ?? [];
    final newDrawing = [...currentDrawing, [point]];
    
    // Atualiza o estado de forma imutável
    state = {
      ...state,
      week: {
        ...(state[week] ?? {}),
        issue: newDrawing,
      }
    };
  }

  // Adiciona um ponto ao traço atual
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

  // Limpa o desenho da semana/problema ATUAL
  void clear() {
    final week = getWeekApiFormat(ref.read(currentDateProvider));
    final issue = ref.read(selectedIssueProvider);
    if (issue == null) return;

    state = {
      ...state,
      week: {
        ...(state[week] ?? {}),
        issue: [], // Define como uma lista vazia
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