import '../models/normal_note.dart';
import '../services/database_service.dart';
import 'dart:convert';

class NormalNoteRepository {
  final DatabaseService _db;

  NormalNoteRepository(this._db);

  Future<NormalNote?> getNormalNote(String id) async {
    final db = await _db.database;
    final maps = await db.query(
      'normal_notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return NormalNote.fromMap(maps.first);
  }

  Future<void> saveContent(String id, List<dynamic> delta) async {
    final db = await _db.database;
    await db.update(
      'normal_notes',
      {'content': jsonEncode(delta)},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}