// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StreakModel _$StreakModelFromJson(Map<String, dynamic> json) {
  return _StreakModel.fromJson(json);
}

/// @nodoc
mixin _$StreakModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'habit_id')
  String get habitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'longest_streak')
  int get longestStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active')
  DateTime? get lastActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'shields_held')
  int get shieldsHeld => throw _privateConstructorUsedError;
  @JsonKey(name: 'comeback_count')
  int get comebackCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StreakModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreakModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakModelCopyWith<StreakModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakModelCopyWith<$Res> {
  factory $StreakModelCopyWith(
    StreakModel value,
    $Res Function(StreakModel) then,
  ) = _$StreakModelCopyWithImpl<$Res, StreakModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'habit_id') String habitId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'longest_streak') int longestStreak,
    @JsonKey(name: 'last_active') DateTime? lastActive,
    @JsonKey(name: 'shields_held') int shieldsHeld,
    @JsonKey(name: 'comeback_count') int comebackCount,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$StreakModelCopyWithImpl<$Res, $Val extends StreakModel>
    implements $StreakModelCopyWith<$Res> {
  _$StreakModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreakModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActive = freezed,
    Object? shieldsHeld = null,
    Object? comebackCount = null,
    Object? updatedAt = freezed,
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
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActive: freezed == lastActive
                ? _value.lastActive
                : lastActive // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            shieldsHeld: null == shieldsHeld
                ? _value.shieldsHeld
                : shieldsHeld // ignore: cast_nullable_to_non_nullable
                      as int,
            comebackCount: null == comebackCount
                ? _value.comebackCount
                : comebackCount // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreakModelImplCopyWith<$Res>
    implements $StreakModelCopyWith<$Res> {
  factory _$$StreakModelImplCopyWith(
    _$StreakModelImpl value,
    $Res Function(_$StreakModelImpl) then,
  ) = __$$StreakModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'habit_id') String habitId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'longest_streak') int longestStreak,
    @JsonKey(name: 'last_active') DateTime? lastActive,
    @JsonKey(name: 'shields_held') int shieldsHeld,
    @JsonKey(name: 'comeback_count') int comebackCount,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StreakModelImplCopyWithImpl<$Res>
    extends _$StreakModelCopyWithImpl<$Res, _$StreakModelImpl>
    implements _$$StreakModelImplCopyWith<$Res> {
  __$$StreakModelImplCopyWithImpl(
    _$StreakModelImpl _value,
    $Res Function(_$StreakModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StreakModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActive = freezed,
    Object? shieldsHeld = null,
    Object? comebackCount = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StreakModelImpl(
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
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActive: freezed == lastActive
            ? _value.lastActive
            : lastActive // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shieldsHeld: null == shieldsHeld
            ? _value.shieldsHeld
            : shieldsHeld // ignore: cast_nullable_to_non_nullable
                  as int,
        comebackCount: null == comebackCount
            ? _value.comebackCount
            : comebackCount // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakModelImpl implements _StreakModel {
  const _$StreakModelImpl({
    required this.id,
    @JsonKey(name: 'habit_id') required this.habitId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'current_streak') this.currentStreak = 0,
    @JsonKey(name: 'longest_streak') this.longestStreak = 0,
    @JsonKey(name: 'last_active') this.lastActive,
    @JsonKey(name: 'shields_held') this.shieldsHeld = 0,
    @JsonKey(name: 'comeback_count') this.comebackCount = 0,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$StreakModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'habit_id')
  final String habitId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  final int longestStreak;
  @override
  @JsonKey(name: 'last_active')
  final DateTime? lastActive;
  @override
  @JsonKey(name: 'shields_held')
  final int shieldsHeld;
  @override
  @JsonKey(name: 'comeback_count')
  final int comebackCount;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StreakModel(id: $id, habitId: $habitId, userId: $userId, currentStreak: $currentStreak, longestStreak: $longestStreak, lastActive: $lastActive, shieldsHeld: $shieldsHeld, comebackCount: $comebackCount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.shieldsHeld, shieldsHeld) ||
                other.shieldsHeld == shieldsHeld) &&
            (identical(other.comebackCount, comebackCount) ||
                other.comebackCount == comebackCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    habitId,
    userId,
    currentStreak,
    longestStreak,
    lastActive,
    shieldsHeld,
    comebackCount,
    updatedAt,
  );

  /// Create a copy of StreakModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakModelImplCopyWith<_$StreakModelImpl> get copyWith =>
      __$$StreakModelImplCopyWithImpl<_$StreakModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakModelImplToJson(this);
  }
}

abstract class _StreakModel implements StreakModel {
  const factory _StreakModel({
    required final String id,
    @JsonKey(name: 'habit_id') required final String habitId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'current_streak') final int currentStreak,
    @JsonKey(name: 'longest_streak') final int longestStreak,
    @JsonKey(name: 'last_active') final DateTime? lastActive,
    @JsonKey(name: 'shields_held') final int shieldsHeld,
    @JsonKey(name: 'comeback_count') final int comebackCount,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$StreakModelImpl;

  factory _StreakModel.fromJson(Map<String, dynamic> json) =
      _$StreakModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'habit_id')
  String get habitId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  int get longestStreak;
  @override
  @JsonKey(name: 'last_active')
  DateTime? get lastActive;
  @override
  @JsonKey(name: 'shields_held')
  int get shieldsHeld;
  @override
  @JsonKey(name: 'comeback_count')
  int get comebackCount;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of StreakModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakModelImplCopyWith<_$StreakModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
