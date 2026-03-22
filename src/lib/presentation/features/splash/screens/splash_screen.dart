import 'package:flutter/material.dart';

import 'package:calorhythm/presentation/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/app_icon.png', width: 120, height: 120),
            const SizedBox(height: 48),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Warming up...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onBackground.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
