import 'package:intl/intl.dart';

/// Calcula o número da semana ISO 8601 para uma data.
int _getWeekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = _getWeekNumber(DateTime(date.year - 1, 12, 31));
  } else if (woy > 52) {
    if (date.weekday != 4 && (date.weekday != 3 || !(_isLeapYear(date.year)))) {
      woy = 1;
    }
  }
  return woy;
}

bool _isLeapYear(int year) => (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);


/// Retorna a string da semana no formato exigido pela API (ex: "2025-W42")
String getWeekApiFormat(DateTime date) {
  final year = date.year;
  final weekNumber = _getWeekNumber(date);
  // O 'padLeft' garante que a semana tenha sempre 2 dígitos (ex: W09)
  return '$year-W${weekNumber.toString().padLeft(2, '0')}';
}


/// Retorna a string da semana para exibição ao usuário (ex: "Semana 42 (20/10 - 26/10)")
String getWeekDisplayFormat(DateTime date) {
  final weekNumber = _getWeekNumber(date);
  // Encontra o primeiro dia (Segunda) e o último (Domingo) da semana
  final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
  final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

  final formatter = DateFormat('dd/MM');
  return 'Semana $weekNumber (${formatter.format(firstDayOfWeek)} - ${formatter.format(lastDayOfWeek)})';
}