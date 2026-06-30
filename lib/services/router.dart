import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/auth/auth_screen.dart';
import '../views/home/home_screen.dart';
import '../views/folder/folder_screen.dart';
import '../views/note/normal_note_screen.dart';
import '../views/note/todo_note_screen.dart';
import '../views/archive/archive_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/auth';

    if (!isLoggedIn && !isAuthRoute) return '/auth';
    if (isLoggedIn && isAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
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
      path: '/note/todo/:noteId',
      builder: (context, state) {
        final noteId = state.pathParameters['noteId']!;
        final noteTitle = state.uri.queryParameters['title'] ?? 'To-Do';
        return TodoNoteScreen(noteId: noteId, noteTitle: noteTitle);
      },
    ),
    GoRoute(
      path: '/archive',
      builder: (context, state) => const ArchiveScreen(),
    ),
  ],
);

// Helper to make GoRouter listen to Supabase auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}