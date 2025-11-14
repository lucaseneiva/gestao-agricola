import 'package:week_number/iso.dart';
import 'package:intl/intl.dart';

String getWeekApiFormat(DateTime date) {
  final year = date.year;
  final weekNumber = date.weekNumber;
  return '$year-W$weekNumber';
}

String getWeekDisplayFormat(DateTime date) {
  final weekNumber = date.weekNumber;
  final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
  final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
  final formatter = DateFormat('dd/MM');
  return 'Semana $weekNumber (${formatter.format(firstDayOfWeek)} - ${formatter.format(lastDayOfWeek)})';
}

