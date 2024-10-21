import 'package:eventofacil/presenter/login_presenter.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:eventofacil/view/troca_senha_view.dart';
import 'package:flutter/material.dart';

import 'cadastro_view.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Evento Facil',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(73, 149, 180, 1),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.grey), // Texto cinza
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Texto do label cinza
                  border: UnderlineInputBorder(), // Apenas a margem inferior
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: _passwordController,
                style: const TextStyle(color: Colors.grey), // Texto cinza
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Texto do label cinza
                  border: UnderlineInputBorder(), // Apenas a margem inferior
                ),
              ),
              const SizedBox(height: 84),
              SizedBox(
                width: double.infinity, // Faz o botão ocupar toda a largura
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _presenter.validateLogin(
                      _usernameController.text,
                      _passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Color.fromRGBO(73, 149, 180, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Deixa o botão quadrado
                    ),
                  ),
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(
                      color: Colors.white, // Define a cor do texto como branca
                      fontSize: 18, // Tamanho da fonte (opcional)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrocaSenhaPage()),
                  );
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Color.fromRGBO(73, 149, 180, 1)),
                ),
              ),
              const SizedBox(height: 8),
              const Text('ou'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastroUsuarioPage()),
                  );
                },
                child: const Text(
                  'Cadastre-se',
                  style: TextStyle(color: Color.fromRGBO(73, 149, 180, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showLoginError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Senha ou usuario incorreto'),
          content: const Text(
              "A senha ou usuario estão incorretos, informe novamente!"),
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
  void navigateToDashboard(String login) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(login)),
    );
  }
}
