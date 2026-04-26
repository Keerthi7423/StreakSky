// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_completion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitCompletionModelImpl _$$HabitCompletionModelImplFromJson(
  Map<String, dynamic> json,
) => _$HabitCompletionModelImpl(
  id: json['id'] as String,
  habitId: json['habit_id'] as String,
  userId: json['user_id'] as String,
  completedDate: json['completed_date'] as String,
  note: json['note'] as String?,
  energyLevel: (json['energy_level'] as num?)?.toInt(),
  synced: json['synced'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$HabitCompletionModelImplToJson(
  _$HabitCompletionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'habit_id': instance.habitId,
  'user_id': instance.userId,
  'completed_date': instance.completedDate,
  'note': instance.note,
  'energy_level': instance.energyLevel,
  'synced': instance.synced,
  'created_at': instance.createdAt?.toIso8601String(),
};
