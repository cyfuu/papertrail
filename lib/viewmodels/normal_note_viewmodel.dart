import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import '../models/normal_note.dart';
import '../repositories/normal_note_repository.dart';
import '../services/providers.dart';

final normalNoteRepositoryProvider = Provider<NormalNoteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NormalNoteRepository(db);
});

final normalNoteViewModelProvider =
    AsyncNotifierProvider.family<NormalNoteViewModel, NormalNote?, String>(
  (id) => NormalNoteViewModel(id),
);

class NormalNoteViewModel extends AsyncNotifier<NormalNote?> {
  NormalNoteViewModel(this._id);

  final String _id;
  QuillController? controller;

  NormalNoteRepository get _repo => ref.read(normalNoteRepositoryProvider);

  @override
  Future<NormalNote?> build() async {
    final note = await _repo.getNormalNote(_id);
    _initController(note);
    return note;
  }

  void _initController(NormalNote? note) {
    final delta = note?.deltaJson;
    final doc = (delta == null || delta.isEmpty)
        ? Document()
        : Document.fromJson(delta);

    controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> saveContent() async {
    if (controller == null) return;
    final delta = controller!.document.toDelta().toJson();
    await _repo.saveContent(_id, delta);
  }
}