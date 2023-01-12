// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }
  //initialisation de database

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'eklezia.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {}

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE blocNotes (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, titre TEXT NOT NULL, theme TEXT, notes TEXT, date INTERGER)');
    await db.execute(
        'CREATE TABLE user (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  path TEXT)');
    await db.execute(
        'CREATE TABLE evengiles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, verset  TEXT NOT NULL, temps TEXT NOT NULL, evengile TEXT NOT NULL, date INTERGER)');
    await db.execute(
        'CREATE TABLE communiques (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,date INTERGER, objet TEXT NOT NULL, message TEXT, image BLOB)');
    await db.execute(
        'CREATE TABLE cevbs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,date INTERGER, objet TEXT NOT NULL, message TEXT, image BLOB)');
  }

// lire les notes // comminique
  readDataNotes(String table) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.rawQuery('SELECT * FROM $table ORDER BY date DESC');
    return response;
  }

  //lire les evengiles
  readDataEvengil() async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.rawQuery('SELECT * FROM evengiles ORDER BY date ASC');
    return response;
  }

  readOneEvengil(int date) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.rawQuery('SELECT * FROM evengiles WHERE date = $date');
    return response;
  }

//lire la photo
  readDate(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

//lire le nombre
  readCount(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery('SELECT COUNT() FROM $table ');
    return response;
  }

  insertData(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  updateData(String table, Map<String, Object?> values, String? myWhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: myWhere);
    return response;
  }

  updateCommunique(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values);
    return response;
  }

  delete(String table, String? mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: mywhere);
    return response;
  }

  deleteEvengil(int date) async {
    Database? mydb = await db;
    int response =
        await mydb!.rawDelete('DELETE FROM evengiles WHERE date < $date');
    return response;
  }

  deleteraw(String table) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table);
    return response;
  }
}
