// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_frequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitFrequencyImpl _$$HabitFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$HabitFrequencyImpl(
      type:
          $enumDecodeNullable(_$FrequencyTypeEnumMap, json['type']) ??
          FrequencyType.daily,
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      timesPerWeek: (json['timesPerWeek'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HabitFrequencyImplToJson(
  _$HabitFrequencyImpl instance,
) => <String, dynamic>{
  'type': _$FrequencyTypeEnumMap[instance.type]!,
  'daysOfWeek': instance.daysOfWeek,
  'timesPerWeek': instance.timesPerWeek,
};

const _$FrequencyTypeEnumMap = {
  FrequencyType.daily: 'daily',
  FrequencyType.weekdays: 'weekdays',
  FrequencyType.custom: 'custom',
};
