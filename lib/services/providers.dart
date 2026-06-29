import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

export '../viewmodels/note_viewmodel.dart';

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});