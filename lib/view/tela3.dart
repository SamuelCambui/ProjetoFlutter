import 'package:flutter/material.dart';

class Tela3 extends StatefulWidget {
  const Tela3({Key? key}) : super(key: key);

  @override
  _Tela3State createState() => _Tela3State();
}

class _Tela3State extends State<Tela3> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => {
          Navigator.popUntil(context, ModalRoute.withName('/')),
        },
        child: Text("Tela 1"),
      ),
    );
  }
}
