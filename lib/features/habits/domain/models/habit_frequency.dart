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
  const factory HabitFrequency({
    @Default(FrequencyType.daily) FrequencyType type,
    List<int>? daysOfWeek,
    int? timesPerWeek,
  }) = _HabitFrequency;

  factory HabitFrequency.fromJson(Map<String, dynamic> json) =>
      _$HabitFrequencyFromJson(json);
}
