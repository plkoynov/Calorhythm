import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class CompleteWorkoutSession {
  const CompleteWorkoutSession(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<void> call(int id) => _sessionRepository.complete(id);
}
