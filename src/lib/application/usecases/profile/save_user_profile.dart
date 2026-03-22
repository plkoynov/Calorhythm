import 'package:calorhythm/domain/entities/user_profile.dart';
import 'package:calorhythm/domain/repositories/profile_repository.dart';

class SaveUserProfile {
  const SaveUserProfile(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<void> call(UserProfile profile) => _profileRepository.save(profile);
}
