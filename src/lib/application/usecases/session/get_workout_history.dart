import 'package:calorhythm/application/dtos/workout_history_filter.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class GetWorkoutHistory {
  const GetWorkoutHistory(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<List<WorkoutSession>> call({
    required int limit,
    required int offset,
    WorkoutHistoryFilter filter = const WorkoutHistoryFilter(),
  }) =>
      filter.isActive
          ? _sessionRepository.getPageFiltered(
              limit,
              offset,
              statuses: filter.isStatusActive ? filter.statuses : null,
              from: filter.startDate,
              to: filter.endDate,
            )
          : _sessionRepository.getPage(limit, offset);
}
