import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/todo_note.dart';
import '../../viewmodels/todo_note_viewmodel.dart';

class TodoNoteScreen extends ConsumerWidget {
  final String noteId;
  final String noteTitle;

  const TodoNoteScreen({
    super.key,
    required this.noteId,
    required this.noteTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoNoteViewModelProvider(noteId));

    return todoAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFFAF9F6),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (todo) {
        if (todo == null) {
          return const Scaffold(
            body: Center(child: Text('Note not found')),
          );
        }
        return _TodoNoteBody(
          noteId: noteId,
          noteTitle: noteTitle,
          todo: todo,
        );
      },
    );
  }
}

class _TodoNoteBody extends ConsumerStatefulWidget {
  final String noteId;
  final String noteTitle;
  final TodoNote todo;

  const _TodoNoteBody({
    required this.noteId,
    required this.noteTitle,
    required this.todo,
  });

  @override
  ConsumerState<_TodoNoteBody> createState() => _TodoNoteBodyState();
}

class _TodoNoteBodyState extends ConsumerState<_TodoNoteBody> {
  late TextEditingController _descController;
  DateTime? _selectedDeadline;
  late Priority _selectedPriority;
  late Recurring _selectedRecurring;

  @override
  void initState() {
    super.initState();
    _descController =
        TextEditingController(text: widget.todo.description ?? '');
    _selectedDeadline = widget.todo.deadline;
    _selectedPriority = widget.todo.priority;
    _selectedRecurring = widget.todo.recurring;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.todo.copyWith(
      description: _descController.text.trim(),
      deadline: _selectedDeadline,
      priority: _selectedPriority,
      recurring: _selectedRecurring,
    );
    await ref
        .read(todoNoteViewModelProvider(widget.noteId).notifier)
        .save(updated);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF163328),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDeadline = picked);
  }

  @override
  Widget build(BuildContext context) {
    final todoAsync = ref.watch(todoNoteViewModelProvider(widget.noteId));
    final items = todoAsync.value?.items ?? widget.todo.items;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF163328)),
        title: Text(
          widget.noteTitle,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF163328),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF163328),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          // --- Description ---
          _SectionLabel(label: 'Description'),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 3,
            style: const TextStyle(color: Color(0xFF163328)),
            decoration: InputDecoration(
              hintText: 'What is this task about?',
              hintStyle: const TextStyle(color: Color(0xFF727974)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF163328)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Deadline ---
          _SectionLabel(label: 'Deadline'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDeadline,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E3DF)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: Color(0xFF163328)),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDeadline == null
                        ? 'Set a deadline'
                        : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                    style: TextStyle(
                      color: _selectedDeadline == null
                          ? const Color(0xFF727974)
                          : const Color(0xFF163328),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedDeadline != null)
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedDeadline = null),
                      child: const Icon(Icons.close_rounded,
                          size: 18, color: Color(0xFF727974)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Priority ---
          _SectionLabel(label: 'Priority'),
          const SizedBox(height: 8),
          _PrioritySelector(
            selected: _selectedPriority,
            onChanged: (p) => setState(() => _selectedPriority = p),
          ),
          const SizedBox(height: 20),

          // --- Recurring ---
          _SectionLabel(label: 'Recurring'),
          const SizedBox(height: 8),
          _RecurringSelector(
            selected: _selectedRecurring,
            onChanged: (r) => setState(() => _selectedRecurring = r),
          ),
          const SizedBox(height: 24),

          // --- Checklist ---
          _SectionLabel(label: 'Checklist'),
          const SizedBox(height: 8),
          _ChecklistSection(noteId: widget.noteId, items: items),
        ],
      ),
    );
  }
}

// --- Section Label ---
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF727974),
        letterSpacing: 0.8,
      ),
    );
  }
}

// --- Priority Selector ---
class _PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;

  const _PrioritySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Priority.values.map((p) {
        final isSelected = p == selected;
        final (label, color) = _meta(p);
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFE2E3DF),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF727974),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  (String, Color) _meta(Priority p) {
    switch (p) {
      case Priority.low:
        return ('LOW', const Color(0xFF3A5C4A));
      case Priority.medium:
        return ('MED', const Color(0xFF5C4A3A));
      case Priority.high:
        return ('HIGH', const Color(0xFF5C3A3A));
      case Priority.critical:
        return ('CRIT', const Color(0xFF8B0000));
    }
  }
}

// --- Recurring Selector ---
class _RecurringSelector extends StatelessWidget {
  final Recurring selected;
  final ValueChanged<Recurring> onChanged;

  const _RecurringSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: Recurring.values.map((r) {
        final isSelected = r == selected;
        return ChoiceChip(
          label: Text(r.name[0].toUpperCase() + r.name.substring(1)),
          selected: isSelected,
          onSelected: (_) => onChanged(r),
          selectedColor: const Color(0xFF163328),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF163328),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE2E3DF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }).toList(),
    );
  }
}

// --- Checklist Section ---
class _ChecklistSection extends ConsumerStatefulWidget {
  final String noteId;
  final List<ChecklistItem> items;

  const _ChecklistSection({
    required this.noteId,
    required this.items,
  });

  @override
  ConsumerState<_ChecklistSection> createState() => _ChecklistSectionState();
}

class _ChecklistSectionState extends ConsumerState<_ChecklistSection> {
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final content = _addController.text.trim();
    if (content.isEmpty) return;
    await ref
        .read(todoNoteViewModelProvider(widget.noteId).notifier)
        .addItem(content);
    _addController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Existing items
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.items.length,
          onReorder: (oldIndex, newIndex) {
            final items = List<ChecklistItem>.from(widget.items);
            if (newIndex > oldIndex) newIndex--;
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
            ref
                .read(todoNoteViewModelProvider(widget.noteId).notifier)
                .reorderItems(items);
          },
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return _ChecklistItemTile(
              key: ValueKey(item.id),
              item: item,
              onToggle: () => ref
                  .read(todoNoteViewModelProvider(widget.noteId).notifier)
                  .toggleItem(item),
              onDelete: () => ref
                  .read(todoNoteViewModelProvider(widget.noteId).notifier)
                  .deleteItem(item.id),
            );
          },
        ),

        // Add item field
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addController,
                style: const TextStyle(color: Color(0xFF163328)),
                decoration: InputDecoration(
                  hintText: 'Add a task...',
                  hintStyle: const TextStyle(color: Color(0xFF727974)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF163328)),
                  ),
                ),
                onSubmitted: (_) => _addItem(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addItem,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF163328),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Checklist Item Tile ---
class _ChecklistItemTile extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ChecklistItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E3DF)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: GestureDetector(
          onTap: onToggle,
          child: Icon(
            item.isChecked
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: item.isChecked
                ? const Color(0xFF163328)
                : const Color(0xFF727974),
          ),
        ),
        title: Text(
          item.content,
          style: TextStyle(
            color: item.isChecked
                ? const Color(0xFF727974)
                : const Color(0xFF163328),
            decoration:
                item.isChecked ? TextDecoration.lineThrough : null,
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.close_rounded,
                  size: 18, color: Color(0xFF727974)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle_rounded,
                size: 18, color: Color(0xFF727974)),
          ],
        ),
      ),
    );
  }
}