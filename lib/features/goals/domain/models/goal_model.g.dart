// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalModelImpl _$$GoalModelImplFromJson(Map<String, dynamic> json) =>
    _$GoalModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: $enumDecode(_$GoalTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String?,
      targetValue: (json['target_value'] as num?)?.toInt(),
      currentValue: (json['current_value'] as num?)?.toInt() ?? 0,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      linkedHabits:
          (json['linked_habits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      phase: (json['phase'] as num?)?.toInt(),
      isMilestone: json['is_milestone'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
      rolledOver: json['rolled_over'] as bool? ?? false,
      lastResetAt: json['last_reset_at'] == null
          ? null
          : DateTime.parse(json['last_reset_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GoalModelImplToJson(_$GoalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'target_value': instance.targetValue,
      'current_value': instance.currentValue,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'linked_habits': instance.linkedHabits,
      'phase': instance.phase,
      'is_milestone': instance.isMilestone,
      'is_completed': instance.isCompleted,
      'rolled_over': instance.rolledOver,
      'last_reset_at': instance.lastResetAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.weekly: 'weekly',
  GoalType.monthly: 'monthly',
  GoalType.career: 'career',
};
