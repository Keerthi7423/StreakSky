// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_completion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HabitCompletionModel _$HabitCompletionModelFromJson(Map<String, dynamic> json) {
  return _HabitCompletionModel.fromJson(json);
}

/// @nodoc
mixin _$HabitCompletionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'habit_id')
  String get habitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_date')
  String get completedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'synced')
  bool get synced => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HabitCompletionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCompletionModelCopyWith<HabitCompletionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCompletionModelCopyWith<$Res> {
  factory $HabitCompletionModelCopyWith(
    HabitCompletionModel value,
    $Res Function(HabitCompletionModel) then,
  ) = _$HabitCompletionModelCopyWithImpl<$Res, HabitCompletionModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'habit_id') String habitId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'completed_date') String completedDate,
    @JsonKey(name: 'synced') bool synced,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$HabitCompletionModelCopyWithImpl<
  $Res,
  $Val extends HabitCompletionModel
>
    implements $HabitCompletionModelCopyWith<$Res> {
  _$HabitCompletionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? completedDate = null,
    Object? synced = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            habitId: null == habitId
                ? _value.habitId
                : habitId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            completedDate: null == completedDate
                ? _value.completedDate
                : completedDate // ignore: cast_nullable_to_non_nullable
                      as String,
            synced: null == synced
                ? _value.synced
                : synced // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitCompletionModelImplCopyWith<$Res>
    implements $HabitCompletionModelCopyWith<$Res> {
  factory _$$HabitCompletionModelImplCopyWith(
    _$HabitCompletionModelImpl value,
    $Res Function(_$HabitCompletionModelImpl) then,
  ) = __$$HabitCompletionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'habit_id') String habitId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'completed_date') String completedDate,
    @JsonKey(name: 'synced') bool synced,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$HabitCompletionModelImplCopyWithImpl<$Res>
    extends _$HabitCompletionModelCopyWithImpl<$Res, _$HabitCompletionModelImpl>
    implements _$$HabitCompletionModelImplCopyWith<$Res> {
  __$$HabitCompletionModelImplCopyWithImpl(
    _$HabitCompletionModelImpl _value,
    $Res Function(_$HabitCompletionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? completedDate = null,
    Object? synced = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$HabitCompletionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        habitId: null == habitId
            ? _value.habitId
            : habitId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        completedDate: null == completedDate
            ? _value.completedDate
            : completedDate // ignore: cast_nullable_to_non_nullable
                  as String,
        synced: null == synced
            ? _value.synced
            : synced // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitCompletionModelImpl implements _HabitCompletionModel {
  const _$HabitCompletionModelImpl({
    required this.id,
    @JsonKey(name: 'habit_id') required this.habitId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'completed_date') required this.completedDate,
    @JsonKey(name: 'synced') this.synced = false,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$HabitCompletionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitCompletionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'habit_id')
  final String habitId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'completed_date')
  final String completedDate;
  @override
  @JsonKey(name: 'synced')
  final bool synced;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'HabitCompletionModel(id: $id, habitId: $habitId, userId: $userId, completedDate: $completedDate, synced: $synced, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitCompletionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    habitId,
    userId,
    completedDate,
    synced,
    createdAt,
  );

  /// Create a copy of HabitCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitCompletionModelImplCopyWith<_$HabitCompletionModelImpl>
  get copyWith =>
      __$$HabitCompletionModelImplCopyWithImpl<_$HabitCompletionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitCompletionModelImplToJson(this);
  }
}

abstract class _HabitCompletionModel implements HabitCompletionModel {
  const factory _HabitCompletionModel({
    required final String id,
    @JsonKey(name: 'habit_id') required final String habitId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'completed_date') required final String completedDate,
    @JsonKey(name: 'synced') final bool synced,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$HabitCompletionModelImpl;

  factory _HabitCompletionModel.fromJson(Map<String, dynamic> json) =
      _$HabitCompletionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'habit_id')
  String get habitId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'completed_date')
  String get completedDate;
  @override
  @JsonKey(name: 'synced')
  bool get synced;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of HabitCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitCompletionModelImplCopyWith<_$HabitCompletionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
