import 'package:drift/drift.dart';

import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [ProfileTable])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<ProfileTableData?> get() =>
      (select(profileTable)..limit(1)).getSingleOrNull();

  Future<void> upsert(ProfileTableCompanion companion) =>
      into(profileTable).insertOnConflictUpdate(companion);
}
