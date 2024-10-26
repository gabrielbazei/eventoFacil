import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usuario_model.dart';

class UsuarioDAO {
  final String apiUrl = 'http://localhost:3000/usuario';

  Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Usuario.fromMap(user)).toList();
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }

  Future<Usuario?> buscarUsuarioPorCpf(String cpf) async {
    final response = await http.get(Uri.parse('$apiUrl?cpf=$cpf'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        return Usuario.fromMap(jsonResponse[0]);
      } else {
        return null; // Nenhum usuário encontrado com o CPF fornecido.
      }
    } else {
      throw Exception('Erro ao buscar usuário pelo CPF');
    }
  }

  Future<void> inserirUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap()),
    );
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Erro ao inserir usuário');
    }
  }

  Future<int> atualizarUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
    return response.statusCode;
  }

  Future<void> deletarUsuario(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }

  Future<int> trocarSenhaDAO(
      String cpf, String endereco, String cidade, String novaSenha) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/usuario/trocar-senha'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cpf': cpf,
        'endereco': endereco,
        'cidade': cidade,
        'novaSenha': novaSenha,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao trocar senha: ${response.body}');
    }
    return response.statusCode;
  }
}
