import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/repositories/exercise_repository.dart';

class SearchExercises {
  const SearchExercises(this._exerciseRepository);

  final ExerciseRepository _exerciseRepository;

  Future<List<Exercise>> call(String query) {
    if (query.trim().isEmpty) return _exerciseRepository.getAll();
    return _exerciseRepository.searchByName(query);
  }
}
