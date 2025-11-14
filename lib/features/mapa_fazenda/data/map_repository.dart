import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapaRepository {
  final String _baseUrl = 'https://bl4puyempn5ldibjquf6fw454e0synuk.lambda-url.us-east-2.on.aws/';

  final String _username = dotenv.env['API_USERNAME'] ?? '';
  final String _password = dotenv.env['API_PASSWORD'] ?? '';

  Future<Map<String, dynamic>?> getDraw(String weekNumber) async {
    final response = await _postRequest('get-draw', {'weekNumber': weekNumber});

    if(kDebugMode) print('GETDRAW RESPONSE [${response.statusCode}]: ${response.body}');

    if (response.statusCode != 200) {
      return null;
    }

    try {
      final Map<String, dynamic> responseMap = jsonDecode(response.body);
      
      return responseMap['drawData'] as Map<String, dynamic>?;
    } catch (e) {
      if(kDebugMode) print('Falha ao decodificar a resposta do get-draw: $e');
      return null;
    }
  }

  Future<void> saveDraw(String weekNumber, String drawData) async {
    final response = await _postRequest('save-draw', {
      'weekNumber': weekNumber,
      'drawData': drawData,
    });
    print('salvando $weekNumber');
    if (response.statusCode != 200) {
      throw Exception('Falha ao salvar desenho: ${response.body}');
    }
  }

  Future<void> deleteDraw(String weekNumber) async {
    final response = await _postRequest('delete-draw', {
      'weekNumber': weekNumber,
    });

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar desenho: ${response.body}');
    }
  }

  Future<http.Response> _postRequest(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _username,
      'password': _password,
      ...payload,
    });

    return await http.post(url, headers: headers, body: body);
  }
}
