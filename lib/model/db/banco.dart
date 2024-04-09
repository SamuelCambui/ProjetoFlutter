import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco {
  static final Banco instance = Banco._();
  static Database? _database;

  // Construtor privado
  Banco._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _iniDatabase();
    return _database!;
  }

  Future _iniDatabase() async {
    String path = join(await getDatabasesPath(), 'meu_banco2.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE user (
      username TEXT PRIMARY KEY,
      password TEXT,
      ultimo_login TEXT
    )''');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
