import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:calorhythm/infrastructure/persistence/seed/met_values.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/infrastructure/persistence/models/exercise_entry_table.dart';
import 'package:calorhythm/infrastructure/persistence/models/exercise_table.dart';
import 'package:calorhythm/infrastructure/persistence/models/profile_table.dart';
import 'package:calorhythm/infrastructure/persistence/models/workout_session_table.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/daos/exercise_dao.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/daos/exercise_entry_dao.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/daos/profile_dao.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/daos/workout_session_dao.dart';

export '../../models/exercise_entry_table.dart';
export '../../models/exercise_table.dart';
export '../../models/profile_table.dart';
export '../../models/workout_session_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ExerciseTable,
    WorkoutSessionTable,
    ExerciseEntryTable,
    ProfileTable
  ],
  daos: [ExerciseDao, WorkoutSessionDao, ExerciseEntryDao, ProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedExercises();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(
              profileTable,
              profileTable.useRepMultiplierForCalories,
            );
          }
          if (from < 3) {
            await customStatement(
                'ALTER TABLE profile_table ADD COLUMN name TEXT');
          }
        },
      );

  Future<void> _seedExercises() async {
    for (final exercise in MetValues.exercises) {
      await into(exerciseTable).insert(
        ExerciseTableCompanion.insert(
          id: Value(exercise.id),
          name: exercise.name,
          metValue: exercise.metValue,
          colorHex: exercise.colorHex,
          iconName: exercise.iconName,
          referenceRepsPerMinute: Value(exercise.referenceRepsPerMinute),
        ),
      );
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'calorhythm');
  }
}
