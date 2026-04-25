import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit_frequency.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? emoji,
    @JsonKey(name: 'color_hex') String? colorHex,
    @Default(HabitFrequency(type: FrequencyType.daily)) HabitFrequency frequency,
    String? category,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}
