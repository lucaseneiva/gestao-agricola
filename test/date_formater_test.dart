import 'package:flutter_test/flutter_test.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';


void main() {
  group('getWeekApiFormat', () {
    test('deve retornar formato correto para meio da semana', () {
      final date = DateTime(2024, 1, 10); // Quarta-feira, semana 2
      expect(getWeekApiFormat(date), '2024-W2');
    });

    test('deve retornar formato correto para primeiro dia do ano', () {
      final date = DateTime(2024, 1, 1); // Segunda-feira, semana 1
      expect(getWeekApiFormat(date), '2024-W1');
    });

    test('deve retornar formato correto para último dia do ano', () {
      final date = DateTime(2024, 12, 31); // Terça-feira
      final result = getWeekApiFormat(date);
      expect(result, matches(r'^\d{4}-W\d{1,2}$'));
    });

    test('deve retornar formato correto para semana 10 (dois dígitos)', () {
      final date = DateTime(2024, 3, 6); // Semana 10
      expect(getWeekApiFormat(date), '2024-W10');
    });

    test('deve retornar formato correto para diferentes anos', () {
      final date2023 = DateTime(2023, 6, 15);
      final date2025 = DateTime(2025, 6, 15);
      
      expect(getWeekApiFormat(date2023), startsWith('2023-W'));
      expect(getWeekApiFormat(date2025), startsWith('2025-W'));
    });

    test('deve usar o formato ISO 8601 para semanas', () {
      final date = DateTime(2024, 1, 1);
      final result = getWeekApiFormat(date);
      expect(result, matches(r'^\d{4}-W\d{1,2}$'));
    });
  });

  group('getWeekDisplayFormat', () {
    test('deve retornar formato de exibição correto para meio da semana', () {
      final date = DateTime(2024, 1, 10); // Quarta-feira, semana 2
      final result = getWeekDisplayFormat(date);
      expect(result, contains('Semana 2'));
      expect(result, contains('08/01')); // Segunda-feira
      expect(result, contains('14/01')); // Domingo
    });

    test('deve calcular corretamente primeira segunda-feira da semana', () {
      final date = DateTime(2024, 1, 14); // Domingo, semana 2
      final result = getWeekDisplayFormat(date);
      expect(result, contains('08/01 - 14/01'));
    });

    test('deve calcular corretamente para segunda-feira', () {
      final date = DateTime(2024, 1, 8); // Segunda-feira, semana 2
      final result = getWeekDisplayFormat(date);
      expect(result, contains('08/01 - 14/01'));
    });

    test('deve formatar datas com zero à esquerda quando necessário', () {
      final date = DateTime(2024, 1, 3); // Primeira semana
      final result = getWeekDisplayFormat(date);
      expect(result, matches(r'Semana \d+ \(\d{2}/\d{2} - \d{2}/\d{2}\)'));
    });

    test('deve funcionar para mudança de mês', () {
      final date = DateTime(2024, 1, 31); // Quarta-feira
      final result = getWeekDisplayFormat(date);
      // A semana deve incluir dias de janeiro e fevereiro
      expect(result, contains('Semana'));
      expect(result, matches(r'\d{2}/\d{2} - \d{2}/\d{2}'));
    });

    test('deve funcionar para mudança de ano', () {
      final date = DateTime(2024, 1, 1); // Segunda-feira
      final result = getWeekDisplayFormat(date);
      expect(result, contains('Semana 1'));
      expect(result, contains('01/01'));
    });

    test('deve manter formato consistente em todas as semanas do ano', () {
      for (int month = 1; month <= 12; month++) {
        final date = DateTime(2024, month, 15);
        final result = getWeekDisplayFormat(date);
        expect(result, matches(r'^Semana \d{1,2} \(\d{2}/\d{2} - \d{2}/\d{2}\)$'));
      }
    });
  });

  group('Integração entre funções', () {
    test('ambas as funções devem usar o mesmo número de semana', () {
      final date = DateTime(2024, 6, 15);
      final apiFormat = getWeekApiFormat(date);
      final displayFormat = getWeekDisplayFormat(date);
      
      final weekFromApi = int.parse(apiFormat.split('-W')[1]);
      final weekFromDisplay = int.parse(
        displayFormat.split('Semana ')[1].split(' ')[0]
      );
      
      expect(weekFromApi, weekFromDisplay);
    });

    test('deve manter consistência para várias datas', () {
      final dates = [
        DateTime(2024, 1, 1),
        DateTime(2024, 3, 15),
        DateTime(2024, 6, 30),
        DateTime(2024, 12, 31),
      ];

      for (final date in dates) {
        final apiFormat = getWeekApiFormat(date);
        final displayFormat = getWeekDisplayFormat(date);
        
        expect(apiFormat, isNotEmpty);
        expect(displayFormat, isNotEmpty);
        expect(displayFormat, contains('Semana'));
      }
    });
  });
}
