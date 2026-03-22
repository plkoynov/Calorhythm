import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

class WorkoutSessionRepositoryImpl implements WorkoutSessionRepository {
  const WorkoutSessionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<WorkoutSession?> getById(int id) async {
    final row = await _db.workoutSessionDao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<WorkoutSession?> getInProgress() async {
    final row = await _db.workoutSessionDao.getInProgress();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<WorkoutSession>> getCompleted() async {
    final rows = await _db.workoutSessionDao.getCompleted();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<WorkoutSession>> getCompletedInRange(
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _db.workoutSessionDao.getCompletedInRange(from, to);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<WorkoutSession> start(double userWeightKg) async {
    final id = await _db.workoutSessionDao.insert(
      WorkoutSessionTableCompanion.insert(
        startTime: DateTime.now(),
        status: SessionStatus.inProgress,
        userWeightKg: userWeightKg,
      ),
    );
    final row = await _db.workoutSessionDao.getInProgress();
    return _toEntity(row!);
  }

  @override
  Future<void> complete(int id) async {
    await _db.workoutSessionDao.updateStatus(
      id: id,
      status: SessionStatus.completed,
      endTime: DateTime.now(),
    );
  }

  @override
  Future<void> abandon(int id) async {
    await _db.workoutSessionDao.updateStatus(
      id: id,
      status: SessionStatus.abandoned,
      endTime: DateTime.now(),
    );
  }

  @override
  Future<({int sessionCount, double totalCalories})> getStatsForRange(
    DateTime from,
    DateTime to,
  ) =>
      _db.workoutSessionDao.getStatsForRange(from, to);

  @override
  Future<void> delete(int id) async {
    await _db.exerciseEntryDao.deleteForSession(id);
    await _db.workoutSessionDao.deleteById(id);
  }

  WorkoutSession _toEntity(WorkoutSessionTableData row) => WorkoutSession(
        id: row.id,
        startTime: row.startTime,
        endTime: row.endTime,
        status: row.status,
        userWeightKg: row.userWeightKg,
      );
}
