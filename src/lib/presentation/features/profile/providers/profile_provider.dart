import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/user_profile.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserProfile?> userProfile(Ref ref) =>
    ref.watch(getUserProfileProvider).call();

@riverpod
class ProfileSaver extends _$ProfileSaver {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> save(UserProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(saveUserProfileProvider).call(profile),
    );
    ref.invalidate(userProfileProvider);
  }
}
