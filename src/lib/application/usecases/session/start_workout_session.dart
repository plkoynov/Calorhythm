import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/domain/repositories/profile_repository.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

/// Fetches the user's weight from their profile then starts a new session.
/// Defaults to 70 kg when no profile exists yet.
class StartWorkoutSession {
  const StartWorkoutSession({
    required ProfileRepository profileRepository,
    required WorkoutSessionRepository sessionRepository,
  })  : _profileRepository = profileRepository,
        _sessionRepository = sessionRepository;

  final ProfileRepository _profileRepository;
  final WorkoutSessionRepository _sessionRepository;

  Future<WorkoutSession> call() async {
    final profile = await _profileRepository.get();
    final weightKg = profile?.weightKg ?? 70.0;
    return _sessionRepository.start(weightKg);
  }
}
