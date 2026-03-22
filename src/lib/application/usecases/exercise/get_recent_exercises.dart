import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';

class GetRecentExercises {
  const GetRecentExercises(this._entryRepository);

  final ExerciseEntryRepository _entryRepository;

  Future<List<Exercise>> call({int limit = 8}) =>
      _entryRepository.getRecentExercises(limit: limit);
}
