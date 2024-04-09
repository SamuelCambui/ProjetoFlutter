import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teste/model/db/banco.dart';


class User {
  String userName;
  String password;
  String ultimologin;

  User(this.userName, this.password, this.ultimologin);

  Future<Map<String, dynamic>> autentica() async {
    final resposta = await http.post(
        Uri.parse('https://tarrafa.unimontes.br/aula/autentica'),
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'username': this.userName, 'password': this.password}));

    return json.decode(resposta.body) as Map<String, dynamic>;
  }

  Future<int> insereUsuario() async {
    final db = await Banco.instance.database;
    return db.rawInsert("""
      INSERT OR REPLACE INTO user (username, password, ultimo_login)
      VALUES ('${this.userName}','${this.password}', '${this.ultimologin}')
    """);
  }

  static Future<User?> verificaUsuario() async {
    final db = await Banco.instance.database;
    List<Map<String, Object?>> lista = await db.rawQuery('SELECT * FROM user');

    if (lista.isNotEmpty) {
      Map<String, Object?> utemp = lista.first;
      User user = User(utemp['username'].toString(), utemp['password'].toString(), utemp['ultimologin'].toString());
      return user;
    }
    return null;
  }

  Future<int> removerUsuario() async {
    final db = await Banco.instance.database;
    return db.rawDelete("""
      DELETE FROM user where userName = '${this.userName}'
    """);
  }
}
