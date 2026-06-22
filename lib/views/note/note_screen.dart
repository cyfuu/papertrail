import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  final String noteId;

  const NoteScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note')),
      body: const Center(child: Text('Note contents')),
    );
  }
}