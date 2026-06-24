import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/note_viewmodel.dart';
import '../../models/note.dart';
import 'widgets/note_type_sheet.dart';
import 'widgets/create_note_dialog.dart';

class FolderScreen extends ConsumerWidget {
  final String folderId;
  final String folderName;

  const FolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(noteViewModelProvider(folderId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          folderName,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF163328),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF163328)),
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notes) => notes.isEmpty
            ? _buildEmptyState(context)
            : _buildNoteList(notes),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddNote(context, ref),
        backgroundColor: const Color(0xFF163328),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _onAddNote(BuildContext context, WidgetRef ref) async {
    final type = await showNoteTypeSheet(context);
    if (type == null) return;

    if (!context.mounted) return;
    final typeLabel = type.name[0].toUpperCase() + type.name.substring(1);
    final title = await showCreateNoteDialog(context, typeLabel);
    if (title == null) return;

    await ref
        .read(noteViewModelProvider(folderId).notifier)
        .createNote(title, type);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF163328).withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.note_outlined,
                size: 48,
                color: Color(0xFF163328),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No notes yet',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF163328),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to create\nyour first note',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF727974),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteList(List<Note> notes) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _NotePlaceholderCard(note: note);
      },
    );
  }
}

// Temporary placeholder — replaced in Task 15
class _NotePlaceholderCard extends StatelessWidget {
  final Note note;

  const _NotePlaceholderCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E3DF)),
      ),
      child: Row(
        children: [
          Icon(
            _iconForType(note.type),
            color: const Color(0xFF163328),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              note.title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF163328),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(NoteType type) {
    switch (type) {
      case NoteType.normal:
        return Icons.edit_note_rounded;
      case NoteType.todo:
        return Icons.checklist_rounded;
      case NoteType.code:
        return Icons.code_rounded;
    }
  }
}