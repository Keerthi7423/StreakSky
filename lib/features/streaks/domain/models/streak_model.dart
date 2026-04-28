import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_model.freezed.dart';
part 'streak_model.g.dart';

@freezed
class StreakModel with _$StreakModel {
  const factory StreakModel({
    required String id,
    @JsonKey(name: 'habit_id') required String habitId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'longest_streak') @Default(0) int longestStreak,
    @JsonKey(name: 'last_active') DateTime? lastActive,
    @JsonKey(name: 'shields_held') @Default(0) int shieldsHeld,
    @JsonKey(name: 'comeback_count') @Default(0) int comebackCount,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _StreakModel;

  factory StreakModel.fromJson(Map<String, dynamic> json) =>
      _$StreakModelFromJson(json);
}
