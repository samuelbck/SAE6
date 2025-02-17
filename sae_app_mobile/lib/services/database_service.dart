// Communication avec la base SQLite
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
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
    Map<String, dynamic> initialData = {
      'name': 'Exemple',
      'latitude': 48.8566,
      'longitude': 2.3522,
      'prediction_score': 0.95,
      'image': Uint8List.fromList([0, 1, 2, 3]),
      'url': 'https://example.fr',
      'timestamp': DateTime.now().toIso8601String(),
    };

    await db.insert('historique', initialData);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('historique', row);
  }

  Future<List<Map<String, dynamic>>> getAllHistorique() async {
    Database? db = await database;
    return await db!.query('historique');
  }

  bool isWeb() {
    return identical(0, 0.0);
  }
}
