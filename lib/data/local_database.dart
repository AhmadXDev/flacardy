import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final String _databaseName = "flacardy_database.db";
  static final int _databaseVersion = 1;

  Database? _database;

  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    Database myDb = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    return myDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "Pockets" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL 
    )
    ''');

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

  // Adding:

  Future<int> addPocket(Pocket pocket) async {
    final db = await database;
    return await db.insert('Pockets', pocket.PocketToRow());
  }

  Future<int> addCard(FlashCard card) async {
    final db = await database;
    return await db.insert('Cards', card.CardToRow());
  }

  // Retrieving:

  Future<List<Pocket>> getPockets() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query('Pockets');

    return rows.map((row) {
      return Pocket(id: row['id'], name: row['name']);
    }).toList();
  }

  Future<List<FlashCard>> getPocketCards(int pocketId) async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'Cards',
      where: 'pocketId = ?',
      whereArgs: [pocketId],
    );

    return rows.map((row) => FlashCard.RowToCard(row)).toList();
  }
}
