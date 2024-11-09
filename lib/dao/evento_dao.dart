import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/event_model.dart';

class EventDAO {
  final String apiUrl = 'https://eventofacil-test.azurewebsites.net/events';

  Future<List<Event>> listarEventos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => Event.fromMap(event)).toList();
    } else {
      throw Exception('Erro ao carregar eventos');
    }
  }

  Future<String> inserirEvento(Event evento) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/inserirEvento'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(evento.toMap()),
      );

      if (response.statusCode != 200) {
        throw Exception('DAO: Erro ao inserir evento');
      }
      return response.body;
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }

  Future<void> atualizarEvento(Event evento) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/${evento.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar evento');
    }
  }

  Future<void> deletarEvento(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar evento');
    }
  }
}
