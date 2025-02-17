import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

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
      CREATE TABLE items(
        id INTEGER PRIMARY KEY,
        name TEXT,
        value INTEGER
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    await db.insert('items', {'id': 1, 'name': 'ben', 'value': 5});
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
