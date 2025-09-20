import 'package:pay_check_app/data/models/receipt_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReceiptRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'receipts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receipts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        organization_name TEXT NOT NULL,
        organization_address TEXT,
        receipt_number TEXT,
        date INTEGER NOT NULL,
        items TEXT,
        total_amount REAL NOT NULL,
        is_taxable INTEGER,
        cashier_name TEXT,
        payment_type INTEGER,
        legal_entity_name TEXT,
        fiscal_number TEXT,
        fiscal_document TEXT,
        fiscal_sign TEXT,
        kkt_registration_number TEXT,
        kkt_factory_number TEXT
      )
    ''');
  }

  Future<int> insertReceipt(Receipt receipt) async {
    final db = await database;
    return await db.insert('receipts', receipt.toMap());
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('receipts');
    return List.generate(maps.length, (i) {
      return Receipt.fromMap(maps[i]);
    });
  }

  Future<int> updateReceipt(Receipt receipt) async {
    final db = await database;
    return await db.update(
      'receipts',
      receipt.toMap(),
      where: 'id = ?',
      whereArgs: [receipt.id],
    );
  }

  Future<int> deleteReceipt(int id) async {
    final db = await database;
    return await db.delete(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Receipt?> getReceiptById(int id) async {
    final db = await database;
    final maps = await db.query(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Receipt.fromMap(maps.first);
    }
    return null;
  }
}