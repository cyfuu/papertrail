import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';
import '../services/providers.dart';

final archiveViewModelProvider =
    AsyncNotifierProvider<ArchiveViewModel, List<Note>>(
  ArchiveViewModel.new,
);

class ArchiveViewModel extends AsyncNotifier<List<Note>> {
  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  Future<List<Note>> build() async {
    return await _repo.getArchivedNotes();
  }

  Future<void> restoreNote(String id) async {
    await _repo.restoreNote(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteNotePermanently(String id) async {
    await _repo.deleteNote(id);
    ref.invalidateSelf();
    await future;
  }
}