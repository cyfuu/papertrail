import 'package:go_router/go_router.dart';
import '../views/home/home_screen.dart';
import '../views/folder/folder_screen.dart';
import '../views/note/normal_note_screen.dart';
import '../views/archive/archive_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/folder/:folderId',
      builder: (context, state) {
        final folderId = state.pathParameters['folderId']!;
        final folderName = state.uri.queryParameters['name'] ?? 'Folder';
        return FolderScreen(folderId: folderId, folderName: folderName);
      },
    ),
    GoRoute(
      path: '/note/normal/:noteId',
      builder: (context, state) {
        final noteId = state.pathParameters['noteId']!;
        final noteTitle = state.uri.queryParameters['title'] ?? 'Note';
        return NormalNoteScreen(noteId: noteId, noteTitle: noteTitle);
      },
    ),
    GoRoute(
      path: '/archive',
      builder: (context, state) => const ArchiveScreen(),
    ),
  ],
);