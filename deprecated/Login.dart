/*import 'package:flutter/material.dart';
import 'package:eventofacil/dashboard.dart';

// O ponto de entrada para o aplicativo Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faça Login',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor principal do app
      ),
      home: MyHomePage(), // Define a tela principal do app
    );
  }
}

// A tela principal do aplicativo
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controladores para capturar o texto dos campos de texto
  final TextEditingController _campo1Controller = TextEditingController();
  final TextEditingController _campo2Controller = TextEditingController();

  // Função que dispara o alerta com o conteúdo dos campos
  void _showAlert() {
    if (_campo1Controller.text == "admin" &&
        _campo2Controller.text == "admin") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavigationBarApp()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Senha incorreta'),
            content: Text("A senha digitada é incorreta, tente novamente!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o alerta
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Título da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento ao redor do corpo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza na tela
          children: <Widget>[
            // Primeiro campo de texto
            TextField(
              controller: _campo1Controller,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            const SizedBox(height: 80), // Espaçamento entre os campos
            // Segundo campo de texto
            TextField(
              obscureText: true,
              controller: _campo2Controller,
              decoration: InputDecoration(labelText: 'Senha'),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showAlert,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}*/
