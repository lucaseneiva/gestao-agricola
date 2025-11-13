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

    // Log para depuração, sempre útil.
    print('GETDRAW RESPONSE [${response.statusCode}]: ${response.body}');

    if (response.statusCode != 200) {
      // Trata casos como 404 (semana sem dados) ou erros de servidor.
      return '';
    }

    try {
      // 1. Decodifica a resposta inteira em um Mapa.
      final Map<String, dynamic> responseMap = jsonDecode(response.body);

      // 2. Acessa a chave 'drawData'. O valor será um Mapa ou nulo.
      final dynamic drawData = responseMap['drawData'];

      // 3. Verifica se 'drawData' é nulo ou não é um Mapa.
      // Se for nulo, significa que a semana existe mas está vazia.
      if (drawData == null || drawData is! Map) {
        return '';
      }
  
      // 4. Se 'drawData' é um Mapa válido, nós o codificamos de volta para uma
      // string JSON. Isso é o que o DrawingAdapter.fromJson espera receber.
      return jsonEncode(drawData);
      
    } catch (e) {
      // Se a resposta não for um JSON válido, retorna vazio para não quebrar o app.
      print('Falha ao decodificar a resposta do get-draw: $e');
      return '';
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