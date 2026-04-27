import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_frequency.freezed.dart';
part 'habit_frequency.g.dart';

enum FrequencyType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekdays')
  weekdays,
  @JsonValue('custom')
  custom,
}

@freezed
class HabitFrequency with _$HabitFrequency {
  const HabitFrequency._();

  const factory HabitFrequency({
    @Default(FrequencyType.daily) FrequencyType type,
    List<int>? daysOfWeek,
    int? timesPerWeek,
  }) = _HabitFrequency;

  factory HabitFrequency.fromJson(Map<String, dynamic> json) =>
      _$HabitFrequencyFromJson(json);

  bool isDue(DateTime date, {int completionsThisWeek = 0}) {
    switch (type) {
      case FrequencyType.daily:
        return true;
      case FrequencyType.weekdays:
        return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
      case FrequencyType.custom:
        if (daysOfWeek != null && daysOfWeek!.isNotEmpty) {
          return daysOfWeek!.contains(date.weekday);
        }
        if (timesPerWeek != null) {
          // If we haven't reached the target for the week, it's "due" every day
          // until the target is met. This is a common pattern for "X times per week".
          return completionsThisWeek < timesPerWeek!;
        }
        return true;
    }
  }
}
