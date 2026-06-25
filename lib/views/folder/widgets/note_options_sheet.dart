import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/note.dart';
import '../../../models/folder.dart';
import '../../../viewmodels/note_viewmodel.dart';
import '../../../viewmodels/folder_viewmodel.dart';

void showNoteOptions(BuildContext context, WidgetRef ref, Note note) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFAF9F6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFC1C8C3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Note title header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF163328),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline,
                  color: Color(0xFF163328)),
              title: const Text('Rename',
                  style: TextStyle(color: Color(0xFF163328))),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context, ref, note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outline,
                  color: Color(0xFF163328)),
              title: const Text('Move to folder',
                  style: TextStyle(color: Color(0xFF163328))),
              onTap: () {
                Navigator.pop(context);
                _showMoveFolderSheet(context, ref, note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined,
                  color: Color(0xFF727974)),
              title: const Text('Archive',
                  style: TextStyle(color: Color(0xFF727974))),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(noteViewModelProvider(note.folderId).notifier)
                    .archiveNote(note.id);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

// --- Rename Dialog ---
void _showRenameDialog(BuildContext context, WidgetRef ref, Note note) {
  final controller = TextEditingController(text: note.title);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFFAF9F6),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Rename Note',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          color: Color(0xFF163328),
        ),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: Color(0xFF163328)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEEEEEA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (_) => _submitRename(context, ref, note, controller),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFF727974))),
        ),
        FilledButton(
          onPressed: () => _submitRename(context, ref, note, controller),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF163328),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void _submitRename(BuildContext context, WidgetRef ref, Note note,
    TextEditingController controller) {
  final title = controller.text.trim();
  if (title.isEmpty) return;
  ref
      .read(noteViewModelProvider(note.folderId).notifier)
      .renameNote(note, title);
  Navigator.pop(context);
}

// --- Move to Folder Sheet ---
void _showMoveFolderSheet(BuildContext context, WidgetRef ref, Note note) {
  final foldersAsync = ref.read(folderViewModelProvider);

  final folders = foldersAsync.value ?? [];
  final otherFolders =
      folders.where((f) => f.id != note.folderId).toList();

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFAF9F6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC1C8C3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Move to folder',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF163328),
              ),
            ),
            const SizedBox(height: 16),
            if (otherFolders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No other folders available',
                    style: TextStyle(color: Color(0xFF727974)),
                  ),
                ),
              )
            else
              ...otherFolders.map(
                (folder) => _FolderMoveItem(
                  folder: folder,
                  onTap: () {
                    Navigator.pop(context);
                    _moveNote(context, ref, note, folder);
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

void _moveNote(
    BuildContext context, WidgetRef ref, Note note, Folder targetFolder) {
  ref
      .read(noteViewModelProvider(note.folderId).notifier)
      .moveNote(note, targetFolder.id);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Moved to "${targetFolder.name}"'),
      backgroundColor: const Color(0xFF163328),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

// --- Folder item in move sheet ---
class _FolderMoveItem extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;

  const _FolderMoveItem({required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: const Icon(Icons.folder_rounded, color: Color(0xFF2D4A3E)),
      title: Text(
        folder.name,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          color: Color(0xFF163328),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: Color(0xFF727974)),
      onTap: onTap,
    );
  }
}