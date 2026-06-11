import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('larry_soft.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Users table
    await db.execute('''
CREATE TABLE users (
  id $idType,
  username TEXT NOT NULL UNIQUE,
  password $textType,
  email TEXT
)
''');

    // Products table
    await db.execute('''
CREATE TABLE products (
  id $idType,
  name $textType,
  description TEXT,
  price $realType,
  imageUrl $textType,
  category TEXT DEFAULT 'General'
)
''');

    // Cart items table
    await db.execute('''
CREATE TABLE cart_items (
  id $idType,
  productId $integerType,
  userId $integerType,
  quantity $integerType DEFAULT 1,
  FOREIGN KEY (productId) REFERENCES products (id),
  FOREIGN KEY (userId) REFERENCES users (id)
)
''');

    // Seed some initial products
    await _seedProducts(db);
  }

  Future _seedProducts(Database db) async {
    final initialProducts = [
      Product(
        name: 'iPhone 15 Pro',
        description: 'Latest Apple iPhone with Titanium design.',
        price: 999.99,
        imageUrl: 'assets/images/iphone.png',
        category: 'Electronics',
      ),
      Product(
        name: 'MacBook Air M2',
        description: 'Supercharged by M2 chip, thin and light.',
        price: 1199.00,
        imageUrl: 'assets/images/macbook.png',
        category: 'Electronics',
      ),
      Product(
        name: 'Sony WH-1000XM5',
        description: 'Industry leading noise canceling headphones.',
        price: 349.99,
        imageUrl: 'assets/images/headphones.png',
        category: 'Accessories',
      ),
      Product(
        name: 'Samsung Galaxy S23',
        description: 'Powerful Android smartphone with great camera.',
        price: 799.99,
        imageUrl: 'assets/images/samsung.png',
        category: 'Electronics',
      ),
    ];

    for (var product in initialProducts) {
      await db.insert('products', product.toMap());
    }
  }

  // User Operations
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Product Operations
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  // Cart Operations
  Future<int> addToCart(CartItem item) async {
    final db = await instance.database;
    
    // Check if product already in cart for this user
    final existing = await db.query(
      'cart_items',
      where: 'productId = ? AND userId = ?',
      whereArgs: [item.productId, item.userId],
    );

    if (existing.isNotEmpty) {
      int newQuantity = (existing.first['quantity'] as int) + item.quantity;
      return await db.update(
        'cart_items',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      return await db.insert('cart_items', item.toMap());
    }
  }

  Future<List<CartItem>> getCartItems(int userId) async {
    final db = await instance.database;
    
    final result = await db.rawQuery('''
      SELECT cart_items.*, products.name, products.price, products.imageUrl, products.description, products.category
      FROM cart_items
      JOIN products ON cart_items.productId = products.id
      WHERE cart_items.userId = ?
    ''', [userId]);

    return result.map((json) {
      final product = Product(
        id: json['productId'] as int,
        name: json['name'] as String,
        price: json['price'] as double,
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
      );
      return CartItem.fromMap(json, product: product);
    }).toList();
  }

  Future<int> removeFromCart(int cartItemId) async {
    final db = await instance.database;
    return await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> clearCart(int userId) async {
    final db = await instance.database;
    await db.delete(
      'cart_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
