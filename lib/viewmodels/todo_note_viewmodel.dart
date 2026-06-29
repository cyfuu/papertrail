import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_note.dart';
import '../repositories/todo_note_repository.dart';
import '../services/providers.dart';

final todoNoteRepositoryProvider = Provider<TodoNoteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TodoNoteRepository(db);
});

final todoNoteViewModelProvider =
    AsyncNotifierProvider.family<TodoNoteViewModel, TodoNote?, String>(
  (id) => TodoNoteViewModel(id),
);

class TodoNoteViewModel extends AsyncNotifier<TodoNote?> {
  TodoNoteViewModel(this._id);

  final String _id;

  TodoNoteRepository get _repo => ref.read(todoNoteRepositoryProvider);

  @override
  Future<TodoNote?> build() async {
    return await _repo.getTodoNote(_id);
  }

  Future<void> save(TodoNote note) async {
    await _repo.saveTodoNote(note);
    ref.invalidateSelf();
    await future;
  }

  Future<void> addItem(String content) async {
    final current = state.value;
    if (current == null) return;
    await _repo.addItem(_id, content, current.items.length);
    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleItem(ChecklistItem item) async {
    final updated = item.copyWith(isChecked: !item.isChecked);
    await _repo.updateItem(updated);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteItem(String itemId) async {
    await _repo.deleteItem(itemId);
    ref.invalidateSelf();
    await future;
  }

  Future<void> reorderItems(List<ChecklistItem> items) async {
    await _repo.reorderItems(items);
    ref.invalidateSelf();
    await future;
  }
}