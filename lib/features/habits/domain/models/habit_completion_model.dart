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
    @JsonKey(name: 'synced') @Default(false) bool synced,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _HabitCompletionModel;

  factory HabitCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$HabitCompletionModelFromJson(json);
}
