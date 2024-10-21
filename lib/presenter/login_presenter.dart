import 'package:eventofacil/model/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventofacil/dao/usuario_dao.dart';

abstract class LoginView {
  void showLoginError();
  void navigateToDashboard(String username);
}

class LoginPresenter {
  final LoginView view;

  LoginPresenter(this.view);

  void validateLogin(String username, String password) async {
    UsuarioDAO usuarioDAO = UsuarioDAO();

    Usuario? user = await usuarioDAO.buscarUsuarioPorCpf(username);
    if (user != null) {
      if (username == user.cpf && password == user.senha) {
        // Salva o estado do login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('cpf', username);
        view.navigateToDashboard(username);
      }
    } else {
      view.showLoginError();
    }
  }

  //Verifica se o usuario já está logado.
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
