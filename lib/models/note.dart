enum NoteType { normal, todo, code }

class Note {
  final String id;
  final String folderId;
  final String title;
  final NoteType type;
  final bool isPinned;
  final bool isArchived;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.folderId,
    required this.title,
    required this.type,
    this.isPinned = false,
    this.isArchived = false,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      folderId: map['folder_id'] as String,
      title: map['title'] as String,
      type: NoteType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NoteType.normal,
      ),
      isPinned: (map['is_pinned'] as int) == 1,
      isArchived: (map['is_archived'] as int) == 1,
      isDeleted: (map['is_deleted'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folder_id': folderId,
      'title': title,
      'type': type.name,
      'is_pinned': isPinned ? 1 : 0,
      'is_archived': isArchived ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    String? folderId,
    String? title,
    NoteType? type,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      type: type ?? this.type,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}