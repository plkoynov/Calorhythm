import 'package:drift/drift.dart';

class ProfileTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  BoolColumn get useRepMultiplierForCalories =>
      boolean().withDefault(const Constant(false))();
}
