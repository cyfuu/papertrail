import 'dart:convert';

class NormalNote {
  final String id;
  final String content; // flutter_quill Delta JSON

  const NormalNote({
    required this.id,
    required this.content,
  });

  factory NormalNote.fromMap(Map<String, dynamic> map) {
    return NormalNote(
      id: map['id'] as String,
      content: map['content'] as String? ?? '{}',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  // Converts content string to a List for flutter_quill
  List<dynamic> get deltaJson {
    try {
      final decoded = jsonDecode(content);
      if (decoded is List) return decoded;
      return [{"insert": "\n"}];
    } catch (_) {
      return [{"insert": "\n"}];
    }
  }
}