import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/folder.dart';
import '../repositories/folder_repository.dart';
import '../services/database_service.dart';
import '../services/providers.dart';

// Repository provider
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FolderRepository(db);
});

// ViewModel provider
final folderViewModelProvider =
    AsyncNotifierProvider<FolderViewModel, List<Folder>>(() {
  return FolderViewModel();
});

class FolderViewModel extends AsyncNotifier<List<Folder>> {
  final _uuid = const Uuid();

  FolderRepository get _repo => ref.read(folderRepositoryProvider);

  @override
  Future<List<Folder>> build() async {
    return await _repo.getFolders();
  }

  Future<void> createFolder(String name) async {
    final now = DateTime.now();
    final folder = Folder(
      id: _uuid.v4(),
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createFolder(folder);
    ref.invalidateSelf();
    await future;
  }

  Future<void> renameFolder(Folder folder, String newName) async {
    final updated = folder.copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    );
    await _repo.updateFolder(updated);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteFolder(String id) async {
    await _repo.deleteFolder(id);
    ref.invalidateSelf();
    await future;
  }
}