import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';
import '../viewmodels/folder_viewmodel.dart';

export '../viewmodels/folder_viewmodel.dart';

// Database provider - single instance shared across all repositories
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});