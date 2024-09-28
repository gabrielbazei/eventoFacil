import 'package:flutter/material.dart';
import 'package:eventofacil/view/navigation_view.dart';

abstract class LoginView {
  void showLoginError();
  void navigateToDashboard();
}

class LoginPresenter {
  final LoginView view;

  LoginPresenter(this.view);

  // Método para validar as credenciais
  void validateLogin(String username, String password) {
    if (username == "admin" && password == "admin") {
      view.navigateToDashboard();
    } else {
      view.showLoginError();
    }
  }
}
