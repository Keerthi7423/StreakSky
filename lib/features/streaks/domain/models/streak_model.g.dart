// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StreakModelImpl _$$StreakModelImplFromJson(Map<String, dynamic> json) =>
    _$StreakModelImpl(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      shieldsHeld: (json['shields_held'] as num?)?.toInt() ?? 0,
      comebackCount: (json['comeback_count'] as num?)?.toInt() ?? 0,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StreakModelImplToJson(_$StreakModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habit_id': instance.habitId,
      'user_id': instance.userId,
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'last_active': instance.lastActive?.toIso8601String(),
      'shields_held': instance.shieldsHeld,
      'comeback_count': instance.comebackCount,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
