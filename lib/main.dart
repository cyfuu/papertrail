import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PaperTrailApp(),
    ),
  );
}

class PaperTrailApp extends StatelessWidget {
  const PaperTrailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaperTrail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90D9)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('PaperTrail'),
        ),
      ),
    );
  }
}