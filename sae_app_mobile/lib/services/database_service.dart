
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Pour détecter la plateforme

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
 
   Future<Database> _initDatabase() async {
    String dbPath;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      dbPath = await getDatabasesPath(); 

    } else {
      String path = await getDatabasesPath(); 
      dbPath = join(path, 'historique.db');// chemin pour IOS
    }
    return await openDatabase(
        dbPath,
        version: 1,
        onCreate: _onCreate,
      );
    throw UnimplementedError("Platform not supported");
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE historique (
        id INTEGER PRIMARY KEY,
        name TEXT,
        latitude REAL,
        longitude REAL,
        prediction_score REAL,
        image BLOB,
        url TEXT,
        timestamp TEXT
      )
    ''');

    // on désactive l'insertion initiale : uniquement pour les tests
    //await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Image encodée en Base64 pour l'exemple
    String base64Image = 'Ukl';

    final Uint8List imageBytes = base64Decode(base64Image);

    await db.insert(
      'historique',
      {
        'name': 'Place Example',
        'latitude': 34.0522,
        'longitude': -118.2437,
        'prediction_score': 85.6,
        'image': imageBytes,
        'url': 'http://example.com',
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
   Future<List<Map<String, dynamic>>> getAllHistorique() async {
    Database? db = await database;
    return await db!.query('historique');
  }

  Future<void> deleteHistorique(int id) async {
    try {
    Database? db = await database;

    if (db == null) {
      throw Exception("Database is not initialized.");
    }

    await db.delete(
      'historique',
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print("Erreur lors de la suppression de l'élément avec l'id $id : $e");
  }
  }

  Future<void> deleteAll() async {
    try {
      Database? db = await database;

      if (db == null) {
        throw Exception("Database is not initialized.");
      }

      await db.delete('historique');
    } catch (e) {
      print("Erreur lors de la suppression de tous les éléments : $e");
    }
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
  try {
    final db = await database;

    if (db == null) {
      throw Exception("Database is not initialized.");
    }

    // Vérifie que l'image est bien en Uint8List avant d'insérer
    if (data.containsKey('image') && data['image'] is! Uint8List) {
      throw Exception("L'image doit être de type Uint8List");
    }

    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print("Erreur lors de l'insertion en BDD : $e");
  }

  
}

}
