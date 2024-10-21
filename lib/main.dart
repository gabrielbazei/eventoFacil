import 'package:eventofacil/view/login_view.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Necessário para usar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    final String? cpf = prefs.getString('cpf');
    if (cpf != null) {
      runApp(MyApp(home: Dashboard(cpf)));
    }
  } else {
    runApp(MyApp(home: const LoginPage()));
  }
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faça Login',
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      home: home, // Define a tela inicial
    );
  }
}
