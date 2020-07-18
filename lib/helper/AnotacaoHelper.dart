import 'dart:async';

import 'package:flutter_minhas_anotacoes/model/Anotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final String tableName = 'anotation';

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initializeDb();
    return _db;
  }

  void _onCreate(Database db, int version) async {
    String sql =
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, date DATETIME)';
    await db.execute(sql);
  }

  Future<Database> initializeDb() async {
    final pathDb = await getDatabasesPath();
    final localDb = join(pathDb, 'my_anotations.db');

    var db = await openDatabase(localDb, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveAnotation(Anotation anotation) async {
    var dataBase = await db;

    int id = await dataBase.insert(tableName, anotation.toMap());

    return id;
  }

  Future<List<Map<String, dynamic>>> getAnotations() async {
    var dataBase = await db;

    return await dataBase.query(tableName, orderBy: 'date');
  }

  Future<int> updateAnotation(Anotation anotation) async {
    var dataBase = await db;

    return await dataBase.update(tableName, anotation.toMap(),
        where: 'id = ?', whereArgs: [anotation.id]);
  }

  Future<int> removeAnotation(int id) async {
    var dataBase = await db;

    return await dataBase.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
