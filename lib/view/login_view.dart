import 'package:eventofacil/presenter/login_presenter';
import 'package:eventofacil/presenter/navigation_presenter.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginView {
  late LoginPresenter _presenter;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Login'),
            ),
            const SizedBox(height: 80),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _presenter.validateLogin(
                  _usernameController.text,
                  _passwordController.text,
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Implementação dos métodos definidos pela interface LoginView
  @override
  void showLoginError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Senha incorreta'),
          content: const Text("A senha digitada é incorreta, tente novamente!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o alerta
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationExample()),
    );
  }
}
