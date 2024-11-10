import '../model/usuario_model.dart';
import '../dao/usuario_dao.dart';

abstract class CadastroUsuarioView {
  void mostrarMensagem(String mensagem);
}

class CadastroUsuarioPresenter {
  final CadastroUsuarioView view;
  final UsuarioDAO usuarioDAO;
  CadastroUsuarioPresenter(this.view) : usuarioDAO = UsuarioDAO();
  // Método para cadastrar usuário no banco de dados pegando diversas informações
  void cadastrarUsuario(
    String nome,
    String email,
    String cpf,
    String telefone,
    String endereco,
    String numEndereco,
    String cidade,
    DateTime? dataNascimento,
    String genero,
    String senha,
    String confirmaSenha,
  ) async {
    // Validações
    if (nome.isEmpty ||
        email.isEmpty ||
        cpf.isEmpty ||
        telefone.isEmpty ||
        endereco.isEmpty ||
        numEndereco.isEmpty ||
        cidade.isEmpty ||
        senha.isEmpty ||
        confirmaSenha.isEmpty ||
        dataNascimento == null) {
      view.mostrarMensagem('Por favor, preencha todos os campos.');
      return;
    }
    // Validação de senha
    if (senha != confirmaSenha) {
      view.mostrarMensagem('As senhas não coincidem.');
      return;
    }

    // Criação do novo usuário
    Usuario novoUsuario = Usuario(
      id: 0, // O ID deve ser gerado no banco de dados
      nome: nome,
      email: email,
      cpf: cpf,
      telefone: telefone,
      endereco: endereco,
      numEndereco: numEndereco,
      cidade: cidade,
      dataNascimento: dataNascimento,
      genero: genero,
      senha: senha,
    );
    // Inserção do usuário no banco de dados
    try {
      await usuarioDAO.inserirUsuario(novoUsuario);
      view.mostrarMensagem('Cadastro realizado com sucesso!');
    } catch (e) {
      print(e.toString());
      view.mostrarMensagem('Erro ao realizar cadastro: ${e.toString()}');
    }
  }
}