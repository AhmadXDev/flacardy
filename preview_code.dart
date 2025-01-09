import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static final _databaseName = "flashcards.db"; // Database name
  static final _databaseVersion = 1; // Version for future migrations

  static final MyDatabase instance = MyDatabase._privateConstructor();
  MyDatabase._privateConstructor();

  Database? _database;

  // Singleton getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the Pockets table
    await db.execute('''
      CREATE TABLE Pockets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Create the Cards table with a foreign key to Pockets
    await db.execute('''
      CREATE TABLE Cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        front TEXT NOT NULL,
        back TEXT NOT NULL,
        pocketId INTEGER NOT NULL,
        FOREIGN KEY (pocketId) REFERENCES Pockets (id) ON DELETE CASCADE
      )
    ''');
  }

  // Method to add a Pocket
  Future<int> addPocket(String name) async {
    final db = await database;
    return await db.insert('Pockets', {'name': name});
  }

  // Method to add a Card
  Future<int> addCard(String front, String back, int pocketId) async {
    final db = await database;
    return await db.insert('Cards', {
      'front': front,
      'back': back,
      'pocketId': pocketId,
    });
  }

  // Method to retrieve all Pockets
  Future<List<Map<String, dynamic>>> getPockets() async {
    final db = await database;
    return await db.query('Pockets');
  }

  // Method to retrieve all Cards for a specific Pocket
  Future<List<Map<String, dynamic>>> getCardsByPocket(int pocketId) async {
    final db = await database;
    return await db.query(
      'Cards',
      where: 'pocketId = ?',
      whereArgs: [pocketId],
    );
  }

  // Method to delete a Pocket and its associated Cards
  Future<int> deletePocket(int pocketId) async {
    final db = await database;
    return await db.delete(
      'Pockets',
      where: 'id = ?',
      whereArgs: [pocketId],
    );
  }
}
