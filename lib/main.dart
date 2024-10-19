import 'package:eventofacil/view/login_view.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faça Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      //home: const LoginPage(), // Define a tela de login como a tela inicial
      home: const Dashboard(),
    );
  }
}
