import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/user_profile.dart';
import 'package:calorhythm/domain/repositories/profile_repository.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<UserProfile?> get() async {
    final row = await _db.profileDao.get();
    if (row == null) return null;
    return UserProfile(
      weightKg: row.weightKg,
      heightCm: row.heightCm,
      name: row.name,
      useRepMultiplierForCalories: row.useRepMultiplierForCalories,
    );
  }

  @override
  Future<void> save(UserProfile profile) async {
    await _db.profileDao.upsert(
      ProfileTableCompanion(
        name: Value(profile.name),
        weightKg: Value(profile.weightKg),
        heightCm: Value(profile.heightCm),
        useRepMultiplierForCalories: Value(profile.useRepMultiplierForCalories),
      ),
    );
  }
}
