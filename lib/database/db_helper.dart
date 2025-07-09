import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model_database.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('coffee_shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE coffee (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT NOT NULL,
      size TEXT NOT NULL,
      ket TEXT NOT NULL,
      jml_uang TEXT NOT NULL,
      tgl_order TEXT NOT NULL,
      image_url TEXT NOT NULL
    )
    ''');
  }

  Future<ModelDatabase> create(ModelDatabase mdlDatabase) async {
    final db = await instance.database;
    final id = await db.insert('coffee', mdlDatabase.toMap());
    return ModelDatabase(id: id, nama: mdlDatabase.nama, size: mdlDatabase.size,
    ket: mdlDatabase.ket, jml_uang: mdlDatabase.jml_uang, tgl_order: mdlDatabase.tgl_order);
  }

  Future<List<ModelDatabase>> readAllStudents() async {
    final db = await instance.database;
    final result = await db.query('coffee');

    return result.map((json) => ModelDatabase.fromMap(json)).toList();
  }

  Future<int> update(ModelDatabase mdlDatabase) async {
    final db = await instance.database;

    return db.update(
      'coffee',
      mdlDatabase.toMap(),
      where: 'id = ?',
      whereArgs: [mdlDatabase.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'coffee',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}