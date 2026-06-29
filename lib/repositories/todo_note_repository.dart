import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_note.dart';
import '../services/database_service.dart';

class TodoNoteRepository {
  final DatabaseService _db;
  final _uuid = const Uuid();

  TodoNoteRepository(this._db);

  Future<TodoNote?> getTodoNote(String id) async {
    final db = await _db.database;

    final maps = await db.query(
      'todo_notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;

    final itemMaps = await db.query(
      'checklist_items',
      where: 'todo_note_id = ? AND parent_id IS NULL',
      whereArgs: [id],
      orderBy: 'sort_order ASC',
    );

    final items = itemMaps.map((m) => ChecklistItem.fromMap(m)).toList();
    return TodoNote.fromMap(maps.first, items);
  }

  Future<void> saveTodoNote(TodoNote note) async {
    final db = await _db.database;
    await db.update(
      'todo_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<ChecklistItem> addItem(String todoNoteId, String content, int sortOrder) async {
    final db = await _db.database;
    final item = ChecklistItem(
      id: _uuid.v4(),
      todoNoteId: todoNoteId,
      content: content,
      sortOrder: sortOrder,
    );
    await db.insert('checklist_items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  Future<void> updateItem(ChecklistItem item) async {
    final db = await _db.database;
    await db.update(
      'checklist_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(String itemId) async {
    final db = await _db.database;
    await db.delete(
      'checklist_items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> reorderItems(List<ChecklistItem> items) async {
    final db = await _db.database;
    final batch = db.batch();
    for (int i = 0; i < items.length; i++) {
      batch.update(
        'checklist_items',
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [items[i].id],
      );
    }
    await batch.commit(noResult: true);
  }
}