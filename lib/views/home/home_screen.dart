import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/folder_viewmodel.dart';
import '../../models/folder.dart';
import 'widgets/folder_card.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/create_folder_dialog.dart';
import 'widgets/folder_options_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(folderViewModelProvider);
    
    final user = ref.watch(authRepositoryProvider).currentUser;
    final username = user?.userMetadata?['username'] ?? 'Explorer';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'PaperTrail',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF163328),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: const Color(0xFF163328),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: foldersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (folders) => folders.isEmpty
            ? const HomeEmptyState()
            : _buildGrid(context, ref, folders, username),
      ),
      floatingActionButton: _buildFAB(context, ref),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF9F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            color: Color(0xFF163328),
          ),
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF727974))),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authViewModelProvider.notifier).signOut();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
      BuildContext context, WidgetRef ref, List<Folder> folders, String username) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $username!',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF727974),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Collections',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Color(0xFF163328),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${folders.length} folder${folders.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF727974),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == folders.length) {
                  return _ArchiveCard(onTap: () => context.push('/archive'));
                }
                final folder = folders[index];
                return FolderCard(
                  folder: folder,
                  colorIndex: index,
                  onLongPress: () => showFolderOptions(context, ref, folder),
                );
              },
              childCount: folders.length + 1,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildFAB(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => showCreateFolderDialog(context, ref),
      backgroundColor: const Color(0xFF163328),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.create_new_folder_outlined),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ArchiveCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFC1C8C3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 32,
              color: Color(0xFF727974),
            ),
            SizedBox(height: 8),
            Text(
              'Archive',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF727974),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Archived notes',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFB0B4B1),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}