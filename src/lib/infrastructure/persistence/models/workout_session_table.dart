import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';

class WorkoutSessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();

  /// Stored as the enum name string (e.g. 'inProgress').
  TextColumn get status => textEnum<SessionStatus>()();

  RealColumn get userWeightKg => real()();
}
