import 'package:eventofacil/dao/usuario_dao.dart';
import 'package:eventofacil/view/troca_senha_view.dart';

abstract class TrocaSenhaView {
  void mostrarMensagem(String mensagem);
}

class TrocaSenhaPresenter {
  final TrocaSenhaView view; // Change this to TrocaSenhaView

  TrocaSenhaPresenter(this.view);
  // Método para trocar a senha do usuário
  Future<void> trocarSenha(String cpf, String cidade, String endereco,
      String senha, String confirmaSenha) async {
    if (cpf.isEmpty ||
        cidade.isEmpty ||
        endereco.isEmpty ||
        senha.isEmpty ||
        confirmaSenha.isEmpty) {
      view.mostrarMensagem(
          'Todos os campos são obrigatórios.'); // Use view to call mostrarMensagem
      return;
    }
    // Validação de senha
    if (senha != confirmaSenha) {
      view.mostrarMensagem(
          'As senhas não coincidem.'); // Use view to call mostrarMensagem
      return;
    }

    // Lógica para troca de senha (não implementada aqui)
    if (await UsuarioDAO().trocarSenhaDAO(cpf, endereco, cidade, senha) ==
        200) {
      view.mostrarMensagem('Senha trocada com sucesso!');
    } else {
      view.mostrarMensagem('Dados informados estão incorretos!');
    }
    // Use view to call mostrarMensagem
  }
}
