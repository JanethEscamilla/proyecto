import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'score.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'scores_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        puntos INTEGER
      )
    ''');
  }

  Future<int> insertScore(Score score) async {
    final db = await instance.database;
    return await db.insert('scores', score.toMap());
  }

  Future<List<Score>> getScores() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('scores', orderBy: 'puntos DESC');
    return List.generate(maps.length, (i) {
      return Score.fromMap(maps[i]);
    });
  }

  // Añade la función para limpiar el historial
  Future<void> limpiarHistorial() async {
    final db = await instance.database;
    await db.delete('scores');
  }
}