import 'package:calorhythm/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile?> get();
  Future<void> save(UserProfile profile);
}
