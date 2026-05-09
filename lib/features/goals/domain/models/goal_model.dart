import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

enum GoalType {
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('career')
  career,
}

@freezed
class GoalModel with _$GoalModel {
  const GoalModel._();

  const factory GoalModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required GoalType type,
    required String title,
    String? description,
    @JsonKey(name: 'target_value') int? targetValue,
    @JsonKey(name: 'current_value') @Default(0) int currentValue,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'linked_habits') @Default([]) List<String> linkedHabits,
    int? phase,
    @JsonKey(name: 'is_milestone') @Default(false) bool isMilestone,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'rolled_over') @Default(false) bool rolledOver,
    @JsonKey(name: 'last_reset_at') DateTime? lastResetAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  double get progress {
    if (targetValue == null || targetValue == 0) return 0;
    return (currentValue / targetValue!).clamp(0.0, 1.0);
  }
}
