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
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
WorkoutSessionRepository sessionRepository(SessionRepositoryRef ref) =>
    WorkoutSessionRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) =>
    ExerciseRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ExerciseEntryRepository entryRepository(EntryRepositoryRef ref) =>
    ExerciseEntryRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) =>
    ProfileRepositoryImpl(ref.watch(appDatabaseProvider));

// ---------------------------------------------------------------------------
// Application — use case factory providers
// ---------------------------------------------------------------------------

@riverpod
GetActiveSession getActiveSession(GetActiveSessionRef ref) =>
    GetActiveSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetSessionEntries getSessionEntries(GetSessionEntriesRef ref) =>
    GetSessionEntries(ref.watch(entryRepositoryProvider));

@riverpod
SearchExercises searchExercises(SearchExercisesRef ref) =>
    SearchExercises(ref.watch(exerciseRepositoryProvider));

@riverpod
StartWorkoutSession startWorkoutSession(StartWorkoutSessionRef ref) =>
    StartWorkoutSession(
      profileRepository: ref.watch(profileRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
    );

@riverpod
CompleteWorkoutSession completeWorkoutSession(CompleteWorkoutSessionRef ref) =>
    CompleteWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
AbandonWorkoutSession abandonWorkoutSession(AbandonWorkoutSessionRef ref) =>
    AbandonWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetWorkoutHistory getWorkoutHistory(GetWorkoutHistoryRef ref) =>
    GetWorkoutHistory(ref.watch(sessionRepositoryProvider));

@riverpod
DeleteWorkoutSession deleteWorkoutSession(DeleteWorkoutSessionRef ref) =>
    DeleteWorkoutSession(ref.watch(sessionRepositoryProvider));

@riverpod
GetUserProfile getUserProfile(GetUserProfileRef ref) =>
    GetUserProfile(ref.watch(profileRepositoryProvider));

@riverpod
SaveUserProfile saveUserProfile(SaveUserProfileRef ref) =>
    SaveUserProfile(ref.watch(profileRepositoryProvider));

@riverpod
GetRecentExercises getRecentExercises(GetRecentExercisesRef ref) =>
    GetRecentExercises(ref.watch(entryRepositoryProvider));

@riverpod
RecordExerciseSet recordExerciseSet(RecordExerciseSetRef ref) =>
    RecordExerciseSet(
      exerciseRepository: ref.watch(exerciseRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
      entryRepository: ref.watch(entryRepositoryProvider),
    );

@riverpod
GetStatistics getStatistics(GetStatisticsRef ref) =>
    GetStatistics(ref.watch(sessionRepositoryProvider));

@riverpod
GetActivityCharts getActivityCharts(GetActivityChartsRef ref) =>
    GetActivityCharts(
      sessionRepository: ref.watch(sessionRepositoryProvider),
      entryRepository: ref.watch(entryRepositoryProvider),
    );
