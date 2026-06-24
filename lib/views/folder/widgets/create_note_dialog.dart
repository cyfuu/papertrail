import 'package:flutter/material.dart';

Future<String?> showCreateNoteDialog(BuildContext context, String noteType) {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFFAF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'New $noteType',
        style: const TextStyle(
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
          hintText: 'Title',
          hintStyle: const TextStyle(color: Color(0xFF727974)),
          filled: true,
          fillColor: const Color(0xFFEEEEEA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) Navigator.pop(context, value.trim());
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFF727974))),
        ),
        FilledButton(
          onPressed: () {
            final title = controller.text.trim();
            if (title.isNotEmpty) Navigator.pop(context, title);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF163328),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Create'),
        ),
      ],
    ),
  );
}