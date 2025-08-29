import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:partyu/models/user_model.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/models/booking_model.dart';
import 'package:partyu/models/review_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('partyu.db');
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
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        avatar TEXT,
        createdAt TEXT NOT NULL,
        isDemo INTEGER DEFAULT 0
      )
    ''');

    // Venues table
    await db.execute('''
      CREATE TABLE venues (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        rating REAL DEFAULT 0.0,
        price TEXT,
        period TEXT,
        distance TEXT,
        address TEXT,
        images TEXT,
        services TEXT,
        ownerId TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (ownerId) REFERENCES users (id)
      )
    ''');

    // Bookings table
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        venueId TEXT NOT NULL,
        venueName TEXT NOT NULL,
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        duration INTEGER NOT NULL,
        totalPrice REAL NOT NULL,
        depositPercentage INTEGER NOT NULL,
        serviceData TEXT NOT NULL,
        numberOfPeople INTEGER,
        status TEXT DEFAULT 'Pendente',
        depositPaid INTEGER DEFAULT 0,
        depositAmount REAL,
        category TEXT,
        isFromGuide INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        responseDeadline TEXT,
        FOREIGN KEY (venueId) REFERENCES venues (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Reviews table
    await db.execute('''
      CREATE TABLE reviews (
        id TEXT PRIMARY KEY,
        venueId TEXT NOT NULL,
        userId TEXT NOT NULL,
        userName TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        images TEXT,
        likes INTEGER DEFAULT 0,
        dislikes INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (venueId) REFERENCES venues (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Seed initial data
    await _seedInitialData(db);
  }

  Future _seedInitialData(Database db) async {
    // Demo user
    await db.insert('users', {
      'id': 'demo-user-123',
      'email': 'demo@partyu.com',
      'name': 'Usuário Demo',
      'password': 'demo123456',
      'avatar': '',
      'createdAt': DateTime.now().toIso8601String(),
      'isDemo': 1,
    });

    // Sample venues
    await db.insert('venues', {
      'id': '1',
      'name': 'Espaço Premium Events',
      'category': 'Espaços',
      'description': 'Espaço para eventos corporativos e sociais',
      'rating': 4.8,
      'price': 'R\$ 1200,00',
      'period': 'Diária',
      'distance': '2.5 km',
      'address': 'Rua das Flores, 123 - Centro',
      'images': '["https://images.unsplash.com/photo-1613067532651-7075a620c900?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080"]',
      'services': '[{"name":"Espaço Completo","price":"R\$ 1.200,00","period":"Diária"},{"name":"Meio Período","price":"R\$ 800,00","period":"6 horas"}]',
      'ownerId': 'demo-user-123',
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('venues', {
      'id': '2',
      'name': 'João Silva Photography',
      'category': 'Fotógrafos',
      'description': 'Fotografia profissional para eventos',
      'rating': 4.9,
      'price': 'R\$ 800,00',
      'period': 'Evento',
      'distance': '1.8 km',
      'address': 'Av. Central, 456 - Bairro Novo',
      'images': '["https://images.unsplash.com/photo-1668187667597-22efba0e6aac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080"]',
      'services': '[{"name":"Cobertura Completa","price":"R\$ 800,00","period":"Evento"},{"name":"Ensaio","price":"R\$ 300,00","period":"2 horas"}]',
      'ownerId': 'demo-user-123',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // User operations
  Future<User?> createUser(User user) async {
    final db = await instance.database;
    try {
      await db.insert('users', user.toMap());
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Venue operations
  Future<List<Venue>> getVenues() async {
    final db = await instance.database;
    final result = await db.query('venues');
    return result.map((map) => Venue.fromMap(map)).toList();
  }

  Future<Venue?> getVenueById(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'venues',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Venue.fromMap(result.first);
    }
    return null;
  }

  Future<List<Venue>> searchVenues(String? query, String? category) async {
    final db = await instance.database;
    String whereClause = '';
    List<String> whereArgs = [];

    if (query != null && query.isNotEmpty) {
      whereClause += 'name LIKE ? OR description LIKE ?';
      whereArgs.addAll(['%$query%', '%$query%']);
    }

    if (category != null && category.isNotEmpty) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    final result = await db.query(
      'venues',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
    );

    return result.map((map) => Venue.fromMap(map)).toList();
  }

  // Booking operations
  Future<int> createBooking(Booking booking) async {
    final db = await instance.database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Booking.fromMap(map)).toList();
  }

  Future<int> updateBookingStatus(String bookingId, String status) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  // Review operations
  Future<int> createReview(Review review) async {
    final db = await instance.database;
    return await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> getVenueReviews(String venueId) async {
    final db = await instance.database;
    final result = await db.query(
      'reviews',
      where: 'venueId = ?',
      whereArgs: [venueId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Review.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}