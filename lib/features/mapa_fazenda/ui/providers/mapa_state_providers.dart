import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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


// NOVO PROVIDER PARA O DESENHO
@riverpod
class DrawingPoints extends _$DrawingPoints {
  // O estado será uma lista de "traços". Cada traço é uma lista de pontos.
  @override
  List<List<Offset>> build() {
    return [];
  }

  // Inicia um novo traço quando o usuário toca na tela
  void startStroke(Offset point) {
    state = [...state, [point]];
  }

  // Adiciona um ponto ao traço atual enquanto o usuário arrasta o dedo
  void addPoint(Offset point) {
    if (state.isEmpty) return;
    // Pega a lista de traços, exceto o último
    final strokes = state.sublist(0, state.length - 1);
    // Pega o último traço, adiciona o novo ponto e o coloca de volta na lista
    final currentStroke = [...state.last, point];
    state = [...strokes, currentStroke];
  }

  // Limpa todos os desenhos da tela
  void clear() {
    state = [];
  }
}