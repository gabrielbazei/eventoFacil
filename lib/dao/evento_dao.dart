import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/event_model.dart';

class EventDAO {
  final String apiUrl = 'http://localhost:3000/events';

  Future<List<Event>> listarEventos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse.map((event) => Event.fromMap(event)).toList());
      return jsonResponse.map((event) => Event.fromMap(event)).toList();
    } else {
      throw Exception('Erro ao carregar eventos');
    }
  }

  Future<void> inserirEvento(Event evento) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao inserir evento');
    }
  }

  Future<void> atualizarEvento(Event evento) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${evento.id}'),
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
