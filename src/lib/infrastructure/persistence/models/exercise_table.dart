import 'package:drift/drift.dart';

class ExerciseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get metValue => real()();
  TextColumn get colorHex => text()();
  TextColumn get iconName => text()();
  IntColumn get referenceRepsPerMinute => integer().nullable()();
}
