import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/theme/app_theme.dart';
import 'package:calorhythm/presentation/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CalorhythmApp(),
    ),
  );
}

class CalorhythmApp extends StatelessWidget {
  const CalorhythmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Calorhythm',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
