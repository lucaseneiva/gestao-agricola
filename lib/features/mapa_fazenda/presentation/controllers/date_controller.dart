import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';

part 'date_controller.g.dart';

@riverpod
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() => DateTime.now();

  void nextWeek() => state = state.add(const Duration(days: 7));
  void previousWeek() => state = state.subtract(const Duration(days: 7));
  
  // Computed property útil para não repetir getWeekApiFormat na UI
  String get formattedApiWeek => getWeekApiFormat(state);
}