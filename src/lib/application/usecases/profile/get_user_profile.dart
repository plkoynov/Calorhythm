import 'package:calorhythm/domain/entities/user_profile.dart';
import 'package:calorhythm/domain/repositories/profile_repository.dart';

class GetUserProfile {
  const GetUserProfile(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<UserProfile?> call() => _profileRepository.get();
}
