import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/normal_note_viewmodel.dart';

class NormalNoteScreen extends ConsumerWidget {
  final String noteId;
  final String noteTitle;

  const NormalNoteScreen({
    super.key,
    required this.noteId,
    required this.noteTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(normalNoteViewModelProvider(noteId));

    return noteAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFFAF9F6),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (_) {
        final viewModel =
            ref.read(normalNoteViewModelProvider(noteId).notifier);
        final controller = viewModel.controller;

        if (controller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAF9F6),
          appBar: _buildAppBar(context, ref),
          body: SafeArea(
            child: Column(
              children: [
                _buildToolbar(controller),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: QuillEditor.basic(
                      controller: controller,
                      config: const QuillEditorConfig(
                        placeholder: 'Start writing...',
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: const Color(0xFFFAF9F6),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFF163328)),
      title: Text(
        noteTitle,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Color(0xFF163328),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ref
                .read(normalNoteViewModelProvider(noteId).notifier)
                .saveContent();
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text(
            'Save',
            style: TextStyle(
              color: Color(0xFF163328),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(QuillController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: QuillSimpleToolbar(
        controller: controller,
        config: const QuillSimpleToolbarConfig(
          showFontFamily: false,
          showFontSize: false,
          showBackgroundColorButton: false,
          showColorButton: false,
          showClearFormat: false,
          showInlineCode: false,
          showCodeBlock: false,
          showQuote: false,
          showIndent: false,
          showLink: false,
          showUndo: true,
          showRedo: true,
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showListBullets: true,
          showListNumbers: true,
          showHeaderStyle: true,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
        ),
      ),
    );
  }
}