import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';
import '../services/providers.dart';

// Repository provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NoteRepository(db);
});

// Family provider — one instance per folderId
final noteViewModelProvider = AsyncNotifierProvider.family<NoteViewModel, List<Note>, String>(
  (folderId) => NoteViewModel(folderId),
);

class NoteViewModel extends AsyncNotifier<List<Note>> {
  NoteViewModel(this._folderId);

  final _uuid = const Uuid();

  // The folderId passed via the family
  final String _folderId;

  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  Future<List<Note>> build() async {
    return await _repo.getNotes(_folderId);
  }

  Future<void> createNote(String title, NoteType type) async {
    final now = DateTime.now();
    final note = Note(
      id: _uuid.v4(),
      folderId: _folderId,
      title: title,
      type: type,
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createNote(note);
    ref.invalidateSelf();
    await future;
  }

  Future<void> renameNote(Note note, String newTitle) async {
    final updated = note.copyWith(
      title: newTitle,
      updatedAt: DateTime.now(),
    );
    await _repo.updateNote(updated);
    ref.invalidateSelf();
    await future;
  }

  Future<void> archiveNote(String id) async {
    await _repo.archiveNote(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> moveNote(Note note, String newFolderId) async {
    final updated = note.copyWith(
      folderId: newFolderId,
      updatedAt: DateTime.now(),
    );
    await _repo.updateNote(updated);
    ref.invalidateSelf();
    await future;
  }
}