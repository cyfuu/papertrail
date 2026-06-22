import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';

// Database provider
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});