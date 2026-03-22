import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';

class GetSessionEntries {
  const GetSessionEntries(this._entryRepository);

  final ExerciseEntryRepository _entryRepository;

  Future<List<ExerciseEntry>> call(int sessionId) =>
      _entryRepository.getForSession(sessionId);
}
