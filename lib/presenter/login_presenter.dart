import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginView {
  void showLoginError();
  void navigateToDashboard();
}

class LoginPresenter {
  final LoginView view;

  LoginPresenter(this.view);

  void validateLogin(String username, String password) async {
    if (username == "admin" && password == "admin") {
      // Salva o estado do login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      view.navigateToDashboard();
    } else {
      view.showLoginError();
    }
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  //test
}
