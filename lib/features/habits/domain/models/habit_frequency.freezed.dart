// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_frequency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HabitFrequency _$HabitFrequencyFromJson(Map<String, dynamic> json) {
  return _HabitFrequency.fromJson(json);
}

/// @nodoc
mixin _$HabitFrequency {
  FrequencyType get type => throw _privateConstructorUsedError;
  List<int>? get daysOfWeek => throw _privateConstructorUsedError;
  int? get timesPerWeek => throw _privateConstructorUsedError;

  /// Serializes this HabitFrequency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitFrequencyCopyWith<HabitFrequency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitFrequencyCopyWith<$Res> {
  factory $HabitFrequencyCopyWith(
    HabitFrequency value,
    $Res Function(HabitFrequency) then,
  ) = _$HabitFrequencyCopyWithImpl<$Res, HabitFrequency>;
  @useResult
  $Res call({FrequencyType type, List<int>? daysOfWeek, int? timesPerWeek});
}

/// @nodoc
class _$HabitFrequencyCopyWithImpl<$Res, $Val extends HabitFrequency>
    implements $HabitFrequencyCopyWith<$Res> {
  _$HabitFrequencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? daysOfWeek = freezed,
    Object? timesPerWeek = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as FrequencyType,
            daysOfWeek: freezed == daysOfWeek
                ? _value.daysOfWeek
                : daysOfWeek // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            timesPerWeek: freezed == timesPerWeek
                ? _value.timesPerWeek
                : timesPerWeek // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitFrequencyImplCopyWith<$Res>
    implements $HabitFrequencyCopyWith<$Res> {
  factory _$$HabitFrequencyImplCopyWith(
    _$HabitFrequencyImpl value,
    $Res Function(_$HabitFrequencyImpl) then,
  ) = __$$HabitFrequencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FrequencyType type, List<int>? daysOfWeek, int? timesPerWeek});
}

/// @nodoc
class __$$HabitFrequencyImplCopyWithImpl<$Res>
    extends _$HabitFrequencyCopyWithImpl<$Res, _$HabitFrequencyImpl>
    implements _$$HabitFrequencyImplCopyWith<$Res> {
  __$$HabitFrequencyImplCopyWithImpl(
    _$HabitFrequencyImpl _value,
    $Res Function(_$HabitFrequencyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? daysOfWeek = freezed,
    Object? timesPerWeek = freezed,
  }) {
    return _then(
      _$HabitFrequencyImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as FrequencyType,
        daysOfWeek: freezed == daysOfWeek
            ? _value._daysOfWeek
            : daysOfWeek // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        timesPerWeek: freezed == timesPerWeek
            ? _value.timesPerWeek
            : timesPerWeek // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitFrequencyImpl extends _HabitFrequency {
  const _$HabitFrequencyImpl({
    this.type = FrequencyType.daily,
    final List<int>? daysOfWeek,
    this.timesPerWeek,
  }) : _daysOfWeek = daysOfWeek,
       super._();

  factory _$HabitFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitFrequencyImplFromJson(json);

  @override
  @JsonKey()
  final FrequencyType type;
  final List<int>? _daysOfWeek;
  @override
  List<int>? get daysOfWeek {
    final value = _daysOfWeek;
    if (value == null) return null;
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? timesPerWeek;

  @override
  String toString() {
    return 'HabitFrequency(type: $type, daysOfWeek: $daysOfWeek, timesPerWeek: $timesPerWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitFrequencyImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._daysOfWeek,
              _daysOfWeek,
            ) &&
            (identical(other.timesPerWeek, timesPerWeek) ||
                other.timesPerWeek == timesPerWeek));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_daysOfWeek),
    timesPerWeek,
  );

  /// Create a copy of HabitFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitFrequencyImplCopyWith<_$HabitFrequencyImpl> get copyWith =>
      __$$HabitFrequencyImplCopyWithImpl<_$HabitFrequencyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitFrequencyImplToJson(this);
  }
}

abstract class _HabitFrequency extends HabitFrequency {
  const factory _HabitFrequency({
    final FrequencyType type,
    final List<int>? daysOfWeek,
    final int? timesPerWeek,
  }) = _$HabitFrequencyImpl;
  const _HabitFrequency._() : super._();

  factory _HabitFrequency.fromJson(Map<String, dynamic> json) =
      _$HabitFrequencyImpl.fromJson;

  @override
  FrequencyType get type;
  @override
  List<int>? get daysOfWeek;
  @override
  int? get timesPerWeek;

  /// Create a copy of HabitFrequency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitFrequencyImplCopyWith<_$HabitFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
