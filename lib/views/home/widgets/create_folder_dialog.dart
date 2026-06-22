import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/folder_viewmodel.dart';

void showCreateFolderDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFFAF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'New Collection',
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
          hintText: 'Collection name',
          hintStyle: const TextStyle(color: Color(0xFF727974)),
          filled: true,
          fillColor: const Color(0xFFEEEEEA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (_) => _submit(context, ref, controller),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF727974)),
          ),
        ),
        FilledButton(
          onPressed: () => _submit(context, ref, controller),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF163328),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Create'),
        ),
      ],
    ),
  );
}

void _submit(
    BuildContext context, WidgetRef ref, TextEditingController controller) {
  final name = controller.text.trim();
  if (name.isEmpty) return;
  ref.read(folderViewModelProvider.notifier).createFolder(name);
  Navigator.pop(context);
}