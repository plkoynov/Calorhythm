import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/repositories/exercise_repository.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  const ExerciseRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Exercise>> getAll() async {
    final rows = await _db.exerciseDao.getAll();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<Exercise?> getById(int id) async {
    final row = await _db.exerciseDao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<Exercise>> searchByName(String query) async {
    final rows = await _db.exerciseDao.getByName(query);
    return rows.map(_toEntity).toList();
  }

  Exercise _toEntity(ExerciseTableData row) => Exercise(
        id: row.id,
        name: row.name,
        metValue: row.metValue,
        colorHex: row.colorHex,
        iconName: row.iconName,
        referenceRepsPerMinute: row.referenceRepsPerMinute,
      );
}
