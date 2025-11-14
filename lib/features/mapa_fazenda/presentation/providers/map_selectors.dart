import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../controllers/drawing_controller.dart';
import '../controllers/date_controller.dart';
import '../controllers/map_ui_controller.dart';
import '../../domain/entities/stroke.dart';

part 'map_selectors.g.dart';

class DisplayDrawings {
  final List<Stroke> activeStrokes;
  final List<Stroke> inactiveStrokes;
  DisplayDrawings({required this.activeStrokes, required this.inactiveStrokes});
}

@riverpod
DisplayDrawings displayDrawings(Ref ref) {
  // Observer como ficou mais limpo: dependemos de outros providers
  final allDrawings = ref.watch(farmDrawingsProvider);
  final week = ref.watch(currentDateProvider.notifier).formattedApiWeek;
  // Observar a semana tbm é importante para reatividade
  ref.watch(currentDateProvider); 
  
  final selectedIssue = ref.watch(selectedIssueProvider);

  final weekDrawing = allDrawings[week];
  
  if (weekDrawing == null || selectedIssue == null) {
    return DisplayDrawings(activeStrokes: [], inactiveStrokes: []);
  }

  // A lógica de filtro continua a mesma
  final active = <Stroke>[];
  final inactive = <Stroke>[];

  for (final s in weekDrawing.strokes) {
    if (s.issueType == selectedIssue) {
      active.add(s);
    } else {
      inactive.add(s);
    }
  }

  return DisplayDrawings(activeStrokes: active, inactiveStrokes: inactive);
}