import 'package:flutter_test/flutter_test.dart';
import 'package:calorhythm/application/services/calorie_calculator.dart';

void main() {
  group('calculateCalories', () {
    test('calculates base calories from MET, weight, and duration', () {
      // MET=8, 70kg, 3600s (1h) → 8 × 70 × 1 = 560 kcal
      final result = calculateCalories(
        metValue: 8.0,
        weightKg: 70,
        durationSeconds: 3600,
        useRepMultiplier: false,
      );
      expect(result, closeTo(560.0, 0.01));
    });

    test('returns half calories for 30 minutes', () {
      final result = calculateCalories(
        metValue: 8.0,
        weightKg: 70,
        durationSeconds: 1800,
        useRepMultiplier: false,
      );
      expect(result, closeTo(280.0, 0.01));
    });

    test('applies rep multiplier when reps provided', () {
      // referenceRepsPerMinute=20, duration=60s → expected=20 reps
      // actualReps=40 → multiplier=2 → calories×2
      final base = calculateCalories(
        metValue: 5.0,
        weightKg: 70,
        durationSeconds: 60,
        useRepMultiplier: false,
      );
      final withReps = calculateCalories(
        metValue: 5.0,
        weightKg: 70,
        durationSeconds: 60,
        useRepMultiplier: true,
        actualReps: 40,
        referenceRepsPerMinute: 20,
      );
      expect(withReps, closeTo(base * 2, 0.01));
    });

    test('ignores rep multiplier when useRepMultiplier is false', () {
      final base = calculateCalories(
        metValue: 5.0,
        weightKg: 70,
        durationSeconds: 60,
        useRepMultiplier: false,
      );
      final withReps = calculateCalories(
        metValue: 5.0,
        weightKg: 70,
        durationSeconds: 60,
        useRepMultiplier: false,
        actualReps: 40,
        referenceRepsPerMinute: 20,
      );
      expect(withReps, closeTo(base, 0.01));
    });
  });
}
