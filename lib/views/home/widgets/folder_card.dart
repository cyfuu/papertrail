import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/folder.dart';

const _folderPalette = [
  (bg: Color(0xFF2D4A3E), text: Color(0xFFADCEBE), accent: Color(0xFF99B9A9)),
  (bg: Color(0xFF5C4A3A), text: Color(0xFFD4B896), accent: Color(0xFFBFA07A)),
  (bg: Color(0xFF3A4A5C), text: Color(0xFF96B4D4), accent: Color(0xFF7A9FBF)),
  (bg: Color(0xFF4A3A5C), text: Color(0xFFB496D4), accent: Color(0xFF9F7ABF)),
  (bg: Color(0xFF5C3A3A), text: Color(0xFFD49696), accent: Color(0xFFBF7A7A)),
  (bg: Color(0xFF3A5C4A), text: Color(0xFF96D4B4), accent: Color(0xFF7ABF9F)),
];

class FolderCard extends StatelessWidget {
  final Folder folder;
  final int colorIndex;
  final VoidCallback onLongPress;

  const FolderCard({
    super.key,
    required this.folder,
    required this.colorIndex,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _folderPalette[colorIndex % _folderPalette.length];

    return GestureDetector(
      onTap: () => context.push(
        '/folder/${folder.id}?name=${Uri.encodeComponent(folder.name)}',
      ),
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: palette.bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accent.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accent.withOpacity(0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.folder_rounded, size: 48, color: palette.text),
                  const Spacer(),
                  Text(
                    folder.name,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: palette.text,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    folder.createdAt.toLocal().toString().substring(0, 10),
                    style: TextStyle(fontSize: 11, color: palette.accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}