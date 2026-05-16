enum FrequencyType {
  daily,
  weekdays,
  custom,
}

class HabitFrequency {
  final FrequencyType type;
  final List<int>? daysOfWeek;
  final int? timesPerWeek;

  const HabitFrequency({
    this.type = FrequencyType.daily,
    this.daysOfWeek,
    this.timesPerWeek,
  });

  factory HabitFrequency.fromJson(Map<String, dynamic> json) {
    return HabitFrequency(
      type: _parseFrequencyType(json['type'] as String?),
      daysOfWeek: (json['days_of_week'] as List?)?.map((e) => e as int).toList(),
      timesPerWeek: json['times_per_week'] as int?,
    );
  }

  static FrequencyType _parseFrequencyType(String? type) {
    switch (type) {
      case 'daily': return FrequencyType.daily;
      case 'weekdays': return FrequencyType.weekdays;
      case 'custom': return FrequencyType.custom;
      default: return FrequencyType.daily;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'days_of_week': daysOfWeek,
      'times_per_week': timesPerWeek,
    };
  }

  HabitFrequency copyWith({
    FrequencyType? type,
    List<int>? daysOfWeek,
    int? timesPerWeek,
  }) {
    return HabitFrequency(
      type: type ?? this.type,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      timesPerWeek: timesPerWeek ?? this.timesPerWeek,
    );
  }

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
          return completionsThisWeek < timesPerWeek!;
        }
        return true;
    }
  }
}
