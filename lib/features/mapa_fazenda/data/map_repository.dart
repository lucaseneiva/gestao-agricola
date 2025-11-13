import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapaRepository {
  final String _baseUrl =
      'https://bl4puyempn5ldibjquf6fw454e0synuk.lambda-url.us-east-2.on.aws/';
  
  // Suas credenciais devem ser armazenadas de forma segura,
  // mas para este desafio, vamos colocá-las aqui.
   final String _username = dotenv.env['API_USERNAME'] ?? '';
  final String _password = dotenv.env['API_PASSWORD'] ?? '';

  Future<String> getDraw(String weekNumber) async {
    final response = await _postRequest('get-draw', {
      'weekNumber': weekNumber,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // A API retorna o drawData dentro de um campo 'body' que é uma string JSON escapada
      final drawDataString = jsonDecode(body['body'])['drawData'];
      return drawDataString ?? '';
    } else {
      // Se não encontrar dados (404) ou outro erro, retorna vazio
      if(response.statusCode == 404) return '';
      throw Exception('Falha ao buscar dados do desenho: ${response.body}');
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
      String endpoint, Map<String, dynamic> payload) async {
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