import 'package:flutter_application_3/m03/HistoryList.dart';
import 'package:flutter_application_3/m03/ShoppingList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  Database? _database;
  final String _table_name = "shopping_list";
  final String _db_name = "shoppinglist_database.db";
  final int _db_version = 2;
  final String _tablename2 = "history";

  DBhelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    _database ??= await openDatabase(join(await getDatabasesPath(), _db_name),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)',
      );
    }, onUpgrade: (db, oldVersion, newVersion) {
      return db.execute(
        'CREATE TABLE $_tablename2 (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER, tanggal TEXT, jam TEXT)',
      );
    }, version: _db_version);
  }

  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert(
      _table_name,
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ShoppingList>> getmyShopingList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query(_table_name);

      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['sum']);
      });
    }
    return [];
  }

  Future<void> deleteShoppingList(int id) async {
    await _database?.delete(
      _table_name,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDB() async {
    await _database?.close();
  }

  Future<void> deleteAllShoppingList() async {
    await _database?.delete(_table_name);
  }

  Future<void> insertHistoryList(ShoppingList tmp, String tanggal) async {
    // final tmp2 = tmp.toMap();
    final data = {
      'id': tmp.id,
      'name': tmp.name,
      'sum': tmp.sum,
      'tanggal': tanggal,
    };
    await _database?.insert(
      _tablename2,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HistoryList>> getmyHistoryList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query(_tablename2);

      return List.generate(maps.length, (i) {
        return HistoryList(
            maps[i]['id'], maps[i]['name'], maps[i]['sum'], maps[i]['tanggal']);
      });
    }
    return [];
  }
}
