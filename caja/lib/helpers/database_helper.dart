//import 'dart:html';
import 'dart:typed_data';

import 'package:caja/models/buses.dart';
import 'package:caja/models/products.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseHelper {
  //static DatabaseHelper databaseHelper = DatabaseHelper.init();
  static DatabaseHelper databaseHelper = DatabaseHelper.init();
  static Database? _database;

  DatabaseHelper.init();

  String busesDatabase =
      'CREATE TABLE IF NOT EXISTS buses(id INTEGER PRIMARY KEY AUTOINCREMENT,location TEXT)';
  String productsDatabase =
      'CREATE TABLE IF NOT EXISTS products(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price REAL)';

  String asignDatabase =
      'CREATE TABLE IF NOT EXISTS asign(id INTEGER PRIMARY KEY AUTOINCREMENT,bus INTEGER, asign TEXT)';

  String deliveryDatabase =
      'CREATE TABLE IF NOT EXISTS delivery(id INTEGER PRIMARY KEY AUTOINCREMENT,bus INTEGER, delivery TEXT)';

  String dietDatabase =
      'CREATE TABLE IF NOT EXISTS diet(id INTEGER PRIMARY KEY AUTOINCREMENT,bus INTEGER,diet TEXT)';

  String extraDatabase =
      'CREATE TABLE IF NOT EXISTS extra(id INTEGER PRIMARY KEY AUTOINCREMENT,bus INTEGER,extra TEXT)';

  String settingDatabase =
      'CREATE TABLE IF NOT EXISTS setting(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,value REAL)';

  String insertChickenIVURow =
      'INSERT INTO setting (name,value) SELECT name,value FROM (SELECT "chicken_ivu" as name,3.87 as value) t WHERE NOT EXISTS (SELECT 1 FROM setting WHERE setting.name = t.name)';
  String insertIVURow =
      'INSERT INTO setting (name,value) SELECT name,value FROM (SELECT "ivu" as name,7.00 as value) t WHERE NOT EXISTS (SELECT 1 FROM setting WHERE setting.name = t.name)';

  Future<Database> get database async {
    // _database = await initDB();
    return _database ?? await initDB();
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "asset_caja.db");
    //await deleteDatabase(path);

// open the database
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  void createDB(Database db, int version) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        if (await Permission.storage.request().isGranted) {
          await db.execute(busesDatabase);
          await db.execute(productsDatabase);
          await db.execute(asignDatabase);
          await db.execute(deliveryDatabase);
          await db.execute(dietDatabase);
          await db.execute(extraDatabase);
          await db.execute(settingDatabase);
          await db.execute(insertChickenIVURow);
          await db.execute(insertIVURow);
        }
      }
    } else {
      await db.execute(busesDatabase);
      await db.execute(productsDatabase);
      await db.execute(asignDatabase);
      await db.execute(deliveryDatabase);
      await db.execute(dietDatabase);
      await db.execute(extraDatabase);
      await db.execute(settingDatabase);
      await db.execute(insertChickenIVURow);
      await db.execute(insertIVURow);
    }
  }

  Future<List<Map<String, dynamic>>> all(String table) async {
    final db = await database;
    //final List<Map<String, dynamic>> map = await db.query(table);
    return await db.query(table);
  }

  Future<int> add(String table, dynamic model) async {
    Database db = await database;
    return await db.insert(table, model.toMap());
  }

  Future<int> update(String table, dynamic model) async {
    Database db = await database;
    return await db.update(table, model.toMap(),
        where: 'id = ?', whereArgs: [model.getId()]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<dynamic> find(String table, String column, var value) async {
    Database db = await database;
    return await db.query(table, where: '$column = ?', whereArgs: [value]);
  }

  Future<bool> exist(String table, String column, var value) async {
    Database db = await database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT * FROM $table WHERE $column="$value")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<void> closeDB() async {
    Database db = await database;
    _database = null;
    return await db.close();
  }
}
