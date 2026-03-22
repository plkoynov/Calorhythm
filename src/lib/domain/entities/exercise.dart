/// A single exercise definition with its MET value and optional rep reference.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.metValue,
    required this.colorHex,
    required this.iconName,
    this.referenceRepsPerMinute,
  });

  final int id;
  final String name;

  /// Metabolic Equivalent of Task – used for calorie calculation.
  final double metValue;

  /// Hex color string for the exercise tile (e.g. '#FF5722').
  final String colorHex;

  /// Icon identifier (maps to an asset or icon name).
  final String iconName;

  /// If set, enables the optional rep-based calorie multiplier.
  final int? referenceRepsPerMinute;

  bool get supportsRepMultiplier => referenceRepsPerMinute != null;
}
