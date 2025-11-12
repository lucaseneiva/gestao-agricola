import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/domain/entities/drawing_line.dart'; 
import 'package:flutter/material.dart';
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
class DrawingState extends _$DrawingState {
  // O estado será uma lista de linhas
  @override
  List<DrawingLine> build() {
    return [];
  }

  // Ação: Começa uma nova linha quando o usuário toca na tela
  void startLine(Offset startPoint, Color color, double width) {
    state = [
      ...state,
      DrawingLine(points: [startPoint], color: color, strokeWidth: width),
    ];
  }

  // Ação: Adiciona um ponto à última linha que está sendo desenhada
  void addPoint(Offset point) {
    if (state.isEmpty) return; // Segurança, não deve acontecer

    // Pega a última linha da lista
    final lastLine = state.last;
    
    // Cria uma nova lista de pontos para a última linha
    final newPoints = [...lastLine.points, point];
    
    // Atualiza a última linha com a nova lista de pontos
    final updatedLine = lastLine.copyWith(points: newPoints);

    // Atualiza o estado: substitui a última linha antiga pela atualizada
    state = [...state.sublist(0, state.length - 1), updatedLine];
  }
  
  // Ação: Limpa todos os desenhos
  void clear() {
    state = [];
  }
}