import 'package:sqflite/sqflite.dart';
import '../models/folder.dart';
import '../services/database_service.dart';

class FolderRepository {
  final DatabaseService _db;

  FolderRepository(this._db);

  Future<Database> get _database async => await _db.database;

  // Fetch all non-deleted folders
  Future<List<Folder>> getFolders() async {
    final db = await _database;
    final maps = await db.query(
      'folders',
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => Folder.fromMap(map)).toList();
  }

  // Create
  Future<void> createFolder(Folder folder) async {
    final db = await _database;
    await db.insert(
      'folders',
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Rename
  Future<void> updateFolder(Folder folder) async {
    final db = await _database;
    await db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  // Soft delete
  Future<void> deleteFolder(String id) async {
    final db = await _database;
    await db.update(
      'folders',
      {
        'is_deleted': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}