enum Priority { low, medium, high, critical }

enum Recurring { none, daily, weekly, custom }

class ChecklistItem {
  final String id;
  final String todoNoteId;
  final String? parentId;
  final String content;
  final bool isChecked;
  final int sortOrder;

  const ChecklistItem({
    required this.id,
    required this.todoNoteId,
    this.parentId,
    required this.content,
    this.isChecked = false,
    required this.sortOrder,
  });

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as String,
      todoNoteId: map['todo_note_id'] as String,
      parentId: map['parent_id'] as String?,
      content: map['content'] as String,
      isChecked: (map['is_checked'] as int) == 1,
      sortOrder: map['sort_order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo_note_id': todoNoteId,
      'parent_id': parentId,
      'content': content,
      'is_checked': isChecked ? 1 : 0,
      'sort_order': sortOrder,
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? todoNoteId,
    String? parentId,
    String? content,
    bool? isChecked,
    int? sortOrder,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      todoNoteId: todoNoteId ?? this.todoNoteId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      isChecked: isChecked ?? this.isChecked,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class TodoNote {
  final String id;
  final String? description;
  final DateTime? deadline;
  final Priority priority;
  final Recurring recurring;
  final int? recurringInterval;
  final List<ChecklistItem> items;

  const TodoNote({
    required this.id,
    this.description,
    this.deadline,
    this.priority = Priority.low,
    this.recurring = Recurring.none,
    this.recurringInterval,
    this.items = const [],
  });

  factory TodoNote.fromMap(
      Map<String, dynamic> map, List<ChecklistItem> items) {
    return TodoNote(
      id: map['id'] as String,
      description: map['description'] as String?,
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
      priority: Priority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => Priority.low,
      ),
      recurring: Recurring.values.firstWhere(
        (e) => e.name == map['recurring'],
        orElse: () => Recurring.none,
      ),
      recurringInterval: map['recurring_interval'] as int?,
      items: items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'deadline': deadline?.toIso8601String(),
      'priority': priority.name,
      'recurring': recurring.name,
      'recurring_interval': recurringInterval,
    };
  }

  TodoNote copyWith({
    String? id,
    String? description,
    DateTime? deadline,
    Priority? priority,
    Recurring? recurring,
    int? recurringInterval,
    List<ChecklistItem>? items,
  }) {
    return TodoNote(
      id: id ?? this.id,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      recurring: recurring ?? this.recurring,
      recurringInterval: recurringInterval ?? this.recurringInterval,
      items: items ?? this.items,
    );
  }
}