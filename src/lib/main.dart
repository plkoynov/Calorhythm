import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/theme/app_theme.dart';
import 'package:calorhythm/presentation/features/splash/screens/splash_screen.dart';
import 'package:calorhythm/presentation/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CalorhythmApp(),
    ),
  );
}

class CalorhythmApp extends StatefulWidget {
  const CalorhythmApp({super.key});

  @override
  State<CalorhythmApp> createState() => _CalorhythmAppState();
}

class _CalorhythmAppState extends State<CalorhythmApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      );
    }

    return MaterialApp.router(
      title: 'Calorhythm',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
