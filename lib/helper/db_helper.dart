import 'dart:async';

import 'package:digita_mobile/models/kanban_model.dart';
import 'package:digita_mobile/models/notification_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._internal();

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kanban(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            section TEXT, 
            bab TEXT, 
            keterangan TEXT, 
            due TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE notification(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            body TEXT, 
            receivedAt TEXT,
            isRead INTEGER DEFAULT 0
          )
        ''');
      },
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
    return await db.delete('kanban', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await database;
    return await db.insert('notification', notification.toMap());
  }

  Future<List<NotificationModel>> getNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notification');
    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }

  Future<void> markAsReadNotification(int? id) async {
    final db = await database;
    await db.update(
      'notification',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadNotificationCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM notification WHERE isRead = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
