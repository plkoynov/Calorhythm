import 'package:calorhythm/domain/entities/workout_session.dart';

class WorkoutHistoryFilter {
  const WorkoutHistoryFilter({
    this.statuses = const {},
    this.startDate,
    this.endDate,
  });

  final Set<SessionStatus> statuses;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get isStatusActive => statuses.isNotEmpty;
  bool get isDateActive => startDate != null || endDate != null;
  bool get isActive => isStatusActive || isDateActive;

  WorkoutHistoryFilter copyWith({
    Set<SessionStatus>? statuses,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) =>
      WorkoutHistoryFilter(
        statuses: statuses ?? this.statuses,
        startDate: clearStartDate ? null : (startDate ?? this.startDate),
        endDate: clearEndDate ? null : (endDate ?? this.endDate),
      );

  WorkoutHistoryFilter clearDate() => WorkoutHistoryFilter(statuses: statuses);

  WorkoutHistoryFilter clearStatuses() =>
      WorkoutHistoryFilter(startDate: startDate, endDate: endDate);
}
