import 'package:drift/drift.dart';

import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [ExerciseTable])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  Future<List<ExerciseTableData>> getAll() => select(exerciseTable).get();

  Future<ExerciseTableData?> getById(int id) =>
      (select(exerciseTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ExerciseTableData>> getByName(String query) =>
      (select(exerciseTable)
            ..where((t) => t.name.lower().contains(query.toLowerCase())))
          .get();

  Future<int> insert(ExerciseTableCompanion companion) =>
      into(exerciseTable).insert(companion);
}
