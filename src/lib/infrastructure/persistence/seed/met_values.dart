import 'package:calorhythm/domain/entities/exercise.dart';

/// Seed data – fixed exercise list with MET values sourced from the
/// Compendium of Physical Activities (Ainsworth et al.).
abstract final class MetValues {
  static const List<Exercise> exercises = [
    Exercise(
      id: 1,
      name: 'Push-ups',
      metValue: 3.8,
      colorHex: '#EF5350',
      iconName: 'pushup',
      referenceRepsPerMinute: 20,
    ),
    Exercise(
      id: 2,
      name: 'Squats',
      metValue: 5.0,
      colorHex: '#AB47BC',
      iconName: 'squat',
      referenceRepsPerMinute: 25,
    ),
    Exercise(
      id: 3,
      name: 'Jumping Jacks',
      metValue: 8.0,
      colorHex: '#42A5F5',
      iconName: 'jumping_jacks',
      referenceRepsPerMinute: 40,
    ),
    Exercise(
      id: 4,
      name: 'Plank',
      metValue: 3.5,
      colorHex: '#26A69A',
      iconName: 'plank',
      referenceRepsPerMinute: null,
    ),
    Exercise(
      id: 5,
      name: 'Burpees',
      metValue: 8.0,
      colorHex: '#66BB6A',
      iconName: 'burpee',
      referenceRepsPerMinute: 10,
    ),
    Exercise(
      id: 6,
      name: 'Lunges',
      metValue: 4.0,
      colorHex: '#FFA726',
      iconName: 'lunge',
      referenceRepsPerMinute: 20,
    ),
    Exercise(
      id: 7,
      name: 'Mountain Climbers',
      metValue: 8.0,
      colorHex: '#8D6E63',
      iconName: 'mountain_climber',
      referenceRepsPerMinute: 30,
    ),
    Exercise(
      id: 8,
      name: 'High Knees',
      metValue: 8.0,
      colorHex: '#78909C',
      iconName: 'high_knees',
      referenceRepsPerMinute: 40,
    ),
  ];
}
