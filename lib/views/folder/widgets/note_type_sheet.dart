import 'package:flutter/material.dart';
import '../../../models/note.dart';

class NoteTypeOption {
  final NoteType type;
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const NoteTypeOption({
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const _noteTypes = [
  NoteTypeOption(
    type: NoteType.normal,
    label: 'Note',
    description: 'Free-form text, thoughts, ideas',
    icon: Icons.edit_note_rounded,
    color: Color(0xFF2D4A3E),
  ),
  NoteTypeOption(
    type: NoteType.todo,
    label: 'To-Do',
    description: 'Tasks, checklists, deadlines',
    icon: Icons.checklist_rounded,
    color: Color(0xFF5C4A3A),
  ),
  NoteTypeOption(
    type: NoteType.code,
    label: 'Code',
    description: 'Snippets, markdown, syntax highlighting',
    icon: Icons.code_rounded,
    color: Color(0xFF3A4A5C),
  ),
];

Future<NoteType?> showNoteTypeSheet(BuildContext context) {
  return showModalBottomSheet<NoteType>(
    context: context,
    backgroundColor: const Color(0xFFFAF9F6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFC1C8C3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'New Note',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF163328),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose a note type to get started',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF727974),
            ),
          ),
          const SizedBox(height: 20),
          ..._noteTypes.map((option) => _NoteTypeItem(option: option)),
        ],
      ),
    ),
  );
}

class _NoteTypeItem extends StatelessWidget {
  final NoteTypeOption option;

  const _NoteTypeItem({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, option.type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: option.color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: option.color.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: option.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF727974),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: option.color.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}