import 'package:flutter/material.dart';
import 'package:teste/view/login.dart';
import 'package:teste/view/root.dart';
import 'package:teste/view/inicio.dart';
import 'package:teste/view/tela3.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App de teste",
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Root(),
        '/login': (context) => const Login(),
        '/inicio': (context) => const inicio(),
        '/tela3': (context) => const Tela3(),
      },
    );
  }
}
