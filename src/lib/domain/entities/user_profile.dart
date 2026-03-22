/// The user's physical profile, used for calorie calculations.
class UserProfile {
  const UserProfile({
    required this.weightKg,
    required this.heightCm,
    this.name,
    this.useRepMultiplierForCalories = false,
  });

  final double weightKg;
  final double heightCm;
  final String? name;

  /// When true, rep count is used as an intensity multiplier on the
  /// MET-based calorie estimate. When false, only duration is used.
  final bool useRepMultiplierForCalories;

  UserProfile copyWith({
    double? weightKg,
    double? heightCm,
    String? name,
    bool? useRepMultiplierForCalories,
  }) {
    return UserProfile(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      name: name ?? this.name,
      useRepMultiplierForCalories:
          useRepMultiplierForCalories ?? this.useRepMultiplierForCalories,
    );
  }
}
