import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usuario_event_model.dart';

class UsuarioEventDAO {
  final String apiUrl = 'http://localhost:3000/usuarioevents';

  Future<List<Usuarioevent>> listarUsuarioEvents() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Usuarioevent.fromMap(item)).toList();
    } else {
      throw Exception('Erro ao carregar usuário-eventos');
    }
  }

  Future<List<Usuarioevent>> listarEventosPorUsuario(int idUsuario) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario/$idUsuario'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Usuarioevent.fromMap(item)).toList();
    } else {
      throw Exception('Erro ao carregar eventos do usuário');
    }
  }

  Future<void> inserirUsuarioEvent(Usuarioevent usuarioEvent) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioEvent.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao inserir usuário-evento');
    }
  }

  Future<void> atualizarUsuarioEvent(Usuarioevent usuarioEvent) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${usuarioEvent.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioEvent.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário-evento');
    }
  }

  Future<void> deletarUsuarioEvent(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário-evento');
    }
  }
}
