import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const FolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: const Center(child: Text('Folder contents')),
    );
  }
}