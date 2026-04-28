import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_completion_model.freezed.dart';
part 'habit_completion_model.g.dart';

@freezed
class HabitCompletionModel with _$HabitCompletionModel {
  const factory HabitCompletionModel({
    required String id,
    @JsonKey(name: 'habit_id') required String habitId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'completed_date') required String completedDate,
    String? note,
    @JsonKey(name: 'energy_level') int? energyLevel,
    @JsonKey(name: 'synced') @Default(false) bool synced,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _HabitCompletionModel;

  factory HabitCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$HabitCompletionModelFromJson(json);
}
