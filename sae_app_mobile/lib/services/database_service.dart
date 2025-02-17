// Communication avec la base SQLite
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:typed_data';

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
    if (isWeb()) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = await getDatabasesPath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Créer la table
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

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    String base64String = dotenv.env['IMAGE_BASE64']!;
    Uint8List imageBytes = base64Decode(base64String);
    await db.insert('historique', {'id': 1, 'name': 'Tournesol', 'latitude': 48.289919, 'longitude': 6.941942, 'prediction_score': 0.99, 'image': imageBytes, 'url': 'https://plant.id/media/imgs/28f6894ea6384b10b81fd8167ea5f3ee.jpg','timestamp': '2025-02-17'});
    print('Inserted initial data into the database');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('items', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await database;
    return await db!.query('items');
  }

  bool isWeb() {
    return identical(0, 0.0);
  }
}
