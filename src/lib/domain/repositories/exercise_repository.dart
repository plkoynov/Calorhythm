import 'package:calorhythm/domain/entities/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(int id);
  Future<List<Exercise>> searchByName(String query);
}
