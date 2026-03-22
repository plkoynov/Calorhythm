import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class GetActiveSession {
  const GetActiveSession(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<WorkoutSession?> call() => _sessionRepository.getInProgress();
}
