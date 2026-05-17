
class StreakDateUtils {
  /// Returns the "effective" date for streak calculation.
  /// Task 47: 1-hour midnight grace period logic.
  /// If it's between 00:00 and 01:00, we are effectively still 'yesterday'.
  static DateTime getEffectiveDate([DateTime? now]) {
    final effectiveNow = now ?? DateTime.now();
    if (effectiveNow.hour == 0) {
      // 1-hour grace period
      return effectiveNow.subtract(const Duration(hours: 1));
    }
    return effectiveNow;
  }

  /// Formats a date to YYYY-MM-DD string.
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Returns today's date string with grace period.
  static String getEffectiveTodayString() {
    return formatDate(getEffectiveDate());
  }
}
