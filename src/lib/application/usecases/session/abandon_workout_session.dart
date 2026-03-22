import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class AbandonWorkoutSession {
  const AbandonWorkoutSession(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<void> call(int id) => _sessionRepository.abandon(id);
}
