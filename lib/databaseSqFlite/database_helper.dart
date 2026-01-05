import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/auth.dart';

/// Database helper singleton for SQLite operations
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'revision.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Force recreate database - use this if migration fails
  Future<void> recreateDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'revision.db');

    // Close existing database
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Delete old database
    await deleteDatabase(path);

    // Reinitialize
    _database = await _initDatabase();
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create auth table
    await db.execute('''
      CREATE TABLE auth (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        specialty TEXT,
        classe TEXT,
        subClasse TEXT,
        rememberMe INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create auth table for users upgrading from version 1
      await db.execute('''
        CREATE TABLE auth (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          specialty TEXT,
          classe TEXT,
          subClasse TEXT,
          rememberMe INTEGER NOT NULL DEFAULT 0,
          createdAt TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      // Add classe and subClasse columns for users upgrading from version 2
      try {
        await db.execute('ALTER TABLE auth ADD COLUMN classe TEXT');
        await db.execute('ALTER TABLE auth ADD COLUMN subClasse TEXT');
      } catch (e) {
        // Columns might already exist, ignore error
        print('Migration warning: $e');
      }
    }
  }

  // User CRUD operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Product CRUD operations
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Auth CRUD operations with auto-fix for schema errors
  Future<int> insertAuth(Auth auth) async {
    try {
      final db = await database;
      return await db.insert('auth', auth.toMap());
    } catch (e) {
      // If error contains "no column named classe", recreate database
      if (e.toString().contains('no column named classe') ||
          e.toString().contains('no column named subClasse')) {
        print('Database schema outdated, recreating...');
        await recreateDatabase();
        final db = await database;
        return await db.insert('auth', auth.toMap());
      }
      rethrow;
    }
  }

  Future<Auth?> getAuthByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'auth',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return Auth.fromMap(maps.first);
  }

  Future<Auth?> getAuthById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'auth',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Auth.fromMap(maps.first);
  }

  Future<Auth?> login(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'auth',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isEmpty) return null;
    return Auth.fromMap(maps.first);
  }

  Future<int> updateAuth(Auth auth) async {
    final db = await database;
    return await db.update(
      'auth',
      auth.toMap(),
      where: 'id = ?',
      whereArgs: [auth.id],
    );
  }

  Future<int> deleteAuth(int id) async {
    final db = await database;
    return await db.delete(
      'auth',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('products');
    await db.delete('auth');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

