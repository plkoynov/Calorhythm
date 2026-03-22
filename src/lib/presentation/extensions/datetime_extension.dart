extension DateTimeFormatting on DateTime {
  /// Returns 'HH:mm' formatted string.
  String get timeLabel {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Returns 'dd MMM yyyy' formatted string (e.g. '14 Mar 2026').
  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${day.toString().padLeft(2, '0')} ${months[month - 1]} $year';
  }
}

extension DurationFormatting on int {
  /// Converts seconds to 'mm:ss' display string.
  String get asTimerLabel {
    final m = (this ~/ 60).toString().padLeft(2, '0');
    final s = (this % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
