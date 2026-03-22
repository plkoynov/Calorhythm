import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class DeleteWorkoutSession {
  const DeleteWorkoutSession(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<void> call(int id) => _sessionRepository.delete(id);
}
