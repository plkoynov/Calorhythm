import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class GetWorkoutHistory {
  const GetWorkoutHistory(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<List<WorkoutSession>> call() => _sessionRepository.getCompleted();
}
