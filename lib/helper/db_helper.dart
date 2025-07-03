import 'dart:async';

import 'package:digita_mobile/models/kanban_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'kanban_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE kanban(id INTEGER PRIMARY KEY AUTOINCREMENT, section TEXT, bab TEXT, keterangan TEXT, due TEXT)',
        );
      }
    );
  }

  Future<int> insertKanban(Kanban kanban) async {
    final db = await database;
    return await db.insert('kanban', kanban.toMap());
  }

  Future<List<Kanban>> getKanbans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kanban'); 
    return List.generate(maps.length, (i) {
      return Kanban.fromMap(maps[i]);
    });
  }

  Future<int> updateKanban(Kanban kanban) async {
    final db = await database;
    return await db.update(
      'kanban', 
      kanban.toMap(),
      where: 'id = ?',
      whereArgs: [kanban.id],
    );
  }

  Future<int> deleteKanban(int id) async {
    final db = await database;
    return await db.delete(
      'kanban',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
