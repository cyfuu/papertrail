import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/folder.dart';
import '../../../viewmodels/folder_viewmodel.dart';

void showFolderOptions(
    BuildContext context, WidgetRef ref, Folder folder) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFAF9F6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFC1C8C3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                folder.name,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF163328),
                ),
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
                _showRenameDialog(context, ref, folder);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Color(0xFFBA1A1A)),
              title: const Text('Delete',
                  style: TextStyle(color: Color(0xFFBA1A1A))),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, folder);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void _showRenameDialog(
    BuildContext context, WidgetRef ref, Folder folder) {
  final controller = TextEditingController(text: folder.name);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFFAF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Rename Collection',
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
        onSubmitted: (_) => _submitRename(context, ref, folder, controller),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFF727974))),
        ),
        FilledButton(
          onPressed: () =>
              _submitRename(context, ref, folder, controller),
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

void _submitRename(BuildContext context, WidgetRef ref, Folder folder,
    TextEditingController controller) {
  final name = controller.text.trim();
  if (name.isEmpty) return;
  ref.read(folderViewModelProvider.notifier).renameFolder(folder, name);
  Navigator.pop(context);
}

void _confirmDelete(
    BuildContext context, WidgetRef ref, Folder folder) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFFAF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Delete Collection',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          color: Color(0xFF163328),
        ),
      ),
      content: Text(
        'Delete "${folder.name}"? This cannot be undone.',
        style: const TextStyle(color: Color(0xFF424844)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFF727974))),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(folderViewModelProvider.notifier)
                .deleteFolder(folder.id);
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFBA1A1A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}