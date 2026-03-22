import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';
import 'package:calorhythm/infrastructure/persistence/repositories/exercise_entry_repository_impl.dart';
import 'package:calorhythm/infrastructure/persistence/repositories/exercise_repository_impl.dart';
import 'package:calorhythm/infrastructure/persistence/repositories/profile_repository_impl.dart';
import 'package:calorhythm/infrastructure/persistence/repositories/workout_session_repository_impl.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';
import 'package:calorhythm/domain/repositories/exercise_repository.dart';
import 'package:calorhythm/domain/repositories/profile_repository.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';
import 'package:calorhythm/application/usecases/session/get_active_session.dart';
import 'package:calorhythm/application/usecases/session/start_workout_session.dart';
import 'package:calorhythm/application/usecases/session/complete_workout_session.dart';
import 'package:calorhythm/application/usecases/session/abandon_workout_session.dart';
import 'package:calorhythm/application/usecases/session/get_workout_history.dart';
import 'package:calorhythm/application/usecases/session/delete_workout_session.dart';
import 'package:calorhythm/application/usecases/exercise/get_session_entries.dart';
import 'package:calorhythm/application/usecases/exercise/search_exercises.dart';
import 'package:calorhythm/application/usecases/exercise/get_recent_exercises.dart';
import 'package:calorhythm/application/usecases/exercise/record_exercise_set.dart';
import 'package:calorhythm/application/usecases/profile/get_user_profile.dart';
import 'package:calorhythm/application/usecases/profile/save_user_profile.dart';
import 'package:calorhythm/application/usecases/session/get_statistics.dart';
import 'package:calorhythm/application/usecases/session/get_activity_charts.dart';

part 'app_providers.g.dart';

// ---------------------------------------------------------------------------
// Infrastructure — repositories
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
WorkoutSessionRepository sessionRepository(Ref ref) =>
    WorkoutSessionRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ExerciseRepository exerciseRepository(Ref ref) =>
    ExerciseRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ExerciseEntryRepository entryRepository(Ref ref) =>
    ExerciseEntryRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepositoryImpl(ref.watch(appDatabaseProvider));

// ---------------------------------------------------------------------------
// Application — use case factory providers
// ---------------------------------------------------------------------------

@riverpod
GetActiveSession getActiveSession(Ref ref) =>
    GetActiveSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetSessionEntries getSessionEntries(Ref ref) =>
    GetSessionEntries(ref.watch(entryRepositoryProvider));

@riverpod
SearchExercises searchExercises(Ref ref) =>
    SearchExercises(ref.watch(exerciseRepositoryProvider));

@riverpod
StartWorkoutSession startWorkoutSession(Ref ref) => StartWorkoutSession(
      profileRepository: ref.watch(profileRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
    );

@riverpod
CompleteWorkoutSession completeWorkoutSession(Ref ref) =>
    CompleteWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
AbandonWorkoutSession abandonWorkoutSession(Ref ref) =>
    AbandonWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetWorkoutHistory getWorkoutHistory(Ref ref) =>
    GetWorkoutHistory(ref.watch(sessionRepositoryProvider));

@riverpod
DeleteWorkoutSession deleteWorkoutSession(Ref ref) =>
    DeleteWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetUserProfile getUserProfile(Ref ref) =>
    GetUserProfile(ref.watch(profileRepositoryProvider));

@riverpod
SaveUserProfile saveUserProfile(Ref ref) =>
    SaveUserProfile(ref.watch(profileRepositoryProvider));

@riverpod
GetRecentExercises getRecentExercises(Ref ref) =>
    GetRecentExercises(ref.watch(entryRepositoryProvider));

@riverpod
RecordExerciseSet recordExerciseSet(Ref ref) => RecordExerciseSet(
      exerciseRepository: ref.watch(exerciseRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
      entryRepository: ref.watch(entryRepositoryProvider),
    );

@riverpod
GetStatistics getStatistics(Ref ref) =>
    GetStatistics(ref.watch(sessionRepositoryProvider));

@riverpod
GetActivityCharts getActivityCharts(Ref ref) => GetActivityCharts(
      sessionRepository: ref.watch(sessionRepositoryProvider),
      entryRepository: ref.watch(entryRepositoryProvider),
    );
