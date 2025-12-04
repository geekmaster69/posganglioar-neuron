import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Database get db {
    if (_db == null) {
      throw Exception(
        'Database not initialized. Call DatabaseHelper.init() in main() first.',
      );
    }
    return _db!;
  }

  static Future<void> init() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "my_database.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE visitedTable (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             candyId INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
