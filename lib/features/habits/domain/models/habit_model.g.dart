// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitModelImpl _$$HabitModelImplFromJson(Map<String, dynamic> json) =>
    _$HabitModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String?,
      colorHex: json['color_hex'] as String?,
      frequency: json['frequency'] == null
          ? const HabitFrequency(type: FrequencyType.daily)
          : HabitFrequency.fromJson(json['frequency'] as Map<String, dynamic>),
      category: json['category'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      isArchived: json['is_archived'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$HabitModelImplToJson(_$HabitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'emoji': instance.emoji,
      'color_hex': instance.colorHex,
      'frequency': instance.frequency,
      'category': instance.category,
      'start_date': instance.startDate?.toIso8601String(),
      'is_archived': instance.isArchived,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt?.toIso8601String(),
    };
