import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NoteRepository {
  final DatabaseService _db;

  NoteRepository(this._db);

  Future<Database> get _database async => await _db.database;

  // Fetch all active notes in a folder (not archived, not deleted)
  Future<List<Note>> getNotes(String folderId) async {
    final db = await _database;
    final maps = await db.query(
      'notes',
      where: 'folder_id = ? AND is_archived = 0 AND is_deleted = 0',
      whereArgs: [folderId],
      orderBy: 'is_pinned DESC, updated_at DESC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Fetch all archived notes
  Future<List<Note>> getArchivedNotes() async {
    final db = await _database;
    final maps = await db.query(
      'notes',
      where: 'is_archived = 1 AND is_deleted = 0',
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Create a note + its type-specific row in one transaction
  Future<void> createNote(Note note) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // Insert corresponding type row with defaults
      switch (note.type) {
        case NoteType.normal:
          await txn.insert('normal_notes', {
            'id': note.id,
            'content': '{}',
          });
          break;
        case NoteType.todo:
          await txn.insert('todo_notes', {
            'id': note.id,
            'description': '',
            'priority': 'low',
            'recurring': 'none',
          });
          break;
        case NoteType.code:
          await txn.insert('code_notes', {
            'id': note.id,
            'blocks': '[]',
          });
          break;
      }
    });
  }

  // Update note metadata (title, pinned, etc.)
  Future<void> updateNote(Note note) async {
    final db = await _database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Soft delete → archive
  Future<void> archiveNote(String id) async {
    final db = await _database;
    await db.update(
      'notes',
      {
        'is_archived': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Restore from archive
  Future<void> restoreNote(String id) async {
    final db = await _database;
    await db.update(
      'notes',
      {
        'is_archived': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Permanent delete
  Future<void> deleteNote(String id) async {
    final db = await _database;
    await db.update(
      'notes',
      {
        'is_deleted': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}