import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'papertrail.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createFolders);
    await db.execute(_createNotes);
    await db.execute(_createNormalNotes);
    await db.execute(_createTodoNotes);
    await db.execute(_createChecklistItems);
    await db.execute(_createCodeNotes);
    await db.execute(_createTags);
    await db.execute(_createNoteTags);
    await db.execute(_createSyncQueue);
  }

  // --- TABLES ---

  static const _createFolders = '''
    CREATE TABLE folders (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      is_deleted INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const _createNotes = '''
    CREATE TABLE notes (
      id TEXT PRIMARY KEY,
      folder_id TEXT NOT NULL,
      title TEXT NOT NULL,
      type TEXT NOT NULL,
      is_pinned INTEGER NOT NULL DEFAULT 0,
      is_archived INTEGER NOT NULL DEFAULT 0,
      is_deleted INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (folder_id) REFERENCES folders (id)
    )
  ''';

  static const _createNormalNotes = '''
    CREATE TABLE normal_notes (
      id TEXT PRIMARY KEY,
      content TEXT NOT NULL DEFAULT '{}',
      FOREIGN KEY (id) REFERENCES notes (id)
    )
  ''';

  static const _createTodoNotes = '''
    CREATE TABLE todo_notes (
      id TEXT PRIMARY KEY,
      description TEXT,
      deadline TEXT,
      priority TEXT NOT NULL DEFAULT 'low',
      recurring TEXT NOT NULL DEFAULT 'none',
      recurring_interval INTEGER,
      FOREIGN KEY (id) REFERENCES notes (id)
    )
  ''';

  static const _createChecklistItems = '''
    CREATE TABLE checklist_items (
      id TEXT PRIMARY KEY,
      todo_note_id TEXT NOT NULL,
      parent_id TEXT,
      content TEXT NOT NULL,
      is_checked INTEGER NOT NULL DEFAULT 0,
      sort_order INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (todo_note_id) REFERENCES todo_notes (id)
    )
  ''';

  static const _createCodeNotes = '''
    CREATE TABLE code_notes (
      id TEXT PRIMARY KEY,
      blocks TEXT NOT NULL DEFAULT '[]',
      FOREIGN KEY (id) REFERENCES notes (id)
    )
  ''';

  static const _createTags = '''
    CREATE TABLE tags (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      color TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''';

  static const _createNoteTags = '''
    CREATE TABLE note_tags (
      note_id TEXT NOT NULL,
      tag_id TEXT NOT NULL,
      PRIMARY KEY (note_id, tag_id),
      FOREIGN KEY (note_id) REFERENCES notes (id),
      FOREIGN KEY (tag_id) REFERENCES tags (id)
    )
  ''';

  static const _createSyncQueue = '''
    CREATE TABLE sync_queue (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      record_id TEXT NOT NULL,
      operation TEXT NOT NULL,
      payload TEXT NOT NULL,
      synced INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    )
  ''';
}