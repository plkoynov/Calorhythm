import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';
import 'package:calorhythm/presentation/features/profile/providers/profile_provider.dart';
import 'package:calorhythm/presentation/features/profile/widgets/profile_form.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTitle)),
      body: SingleChildScrollView(
        child: profileAsync.when(
          data: (profile) => ProfileForm(initialProfile: profile),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
