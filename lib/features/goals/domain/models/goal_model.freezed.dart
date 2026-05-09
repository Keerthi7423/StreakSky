// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) {
  return _GoalModel.fromJson(json);
}

/// @nodoc
mixin _$GoalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  GoalType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_value')
  int? get targetValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_value')
  int get currentValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_habits')
  List<String> get linkedHabits => throw _privateConstructorUsedError;
  int? get phase => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_milestone')
  bool get isMilestone => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'rolled_over')
  bool get rolledOver => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GoalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalModelCopyWith<GoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalModelCopyWith<$Res> {
  factory $GoalModelCopyWith(GoalModel value, $Res Function(GoalModel) then) =
      _$GoalModelCopyWithImpl<$Res, GoalModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    GoalType type,
    String title,
    String? description,
    @JsonKey(name: 'target_value') int? targetValue,
    @JsonKey(name: 'current_value') int currentValue,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'linked_habits') List<String> linkedHabits,
    int? phase,
    @JsonKey(name: 'is_milestone') bool isMilestone,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'rolled_over') bool rolledOver,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$GoalModelCopyWithImpl<$Res, $Val extends GoalModel>
    implements $GoalModelCopyWith<$Res> {
  _$GoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetValue = freezed,
    Object? currentValue = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? linkedHabits = null,
    Object? phase = freezed,
    Object? isMilestone = null,
    Object? isCompleted = null,
    Object? rolledOver = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as GoalType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetValue: freezed == targetValue
                ? _value.targetValue
                : targetValue // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as int,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            linkedHabits: null == linkedHabits
                ? _value.linkedHabits
                : linkedHabits // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            phase: freezed == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as int?,
            isMilestone: null == isMilestone
                ? _value.isMilestone
                : isMilestone // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            rolledOver: null == rolledOver
                ? _value.rolledOver
                : rolledOver // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GoalModelImplCopyWith<$Res>
    implements $GoalModelCopyWith<$Res> {
  factory _$$GoalModelImplCopyWith(
    _$GoalModelImpl value,
    $Res Function(_$GoalModelImpl) then,
  ) = __$$GoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    GoalType type,
    String title,
    String? description,
    @JsonKey(name: 'target_value') int? targetValue,
    @JsonKey(name: 'current_value') int currentValue,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'linked_habits') List<String> linkedHabits,
    int? phase,
    @JsonKey(name: 'is_milestone') bool isMilestone,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'rolled_over') bool rolledOver,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$GoalModelImplCopyWithImpl<$Res>
    extends _$GoalModelCopyWithImpl<$Res, _$GoalModelImpl>
    implements _$$GoalModelImplCopyWith<$Res> {
  __$$GoalModelImplCopyWithImpl(
    _$GoalModelImpl _value,
    $Res Function(_$GoalModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetValue = freezed,
    Object? currentValue = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? linkedHabits = null,
    Object? phase = freezed,
    Object? isMilestone = null,
    Object? isCompleted = null,
    Object? rolledOver = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GoalModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as GoalType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetValue: freezed == targetValue
            ? _value.targetValue
            : targetValue // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as int,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        linkedHabits: null == linkedHabits
            ? _value._linkedHabits
            : linkedHabits // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        phase: freezed == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as int?,
        isMilestone: null == isMilestone
            ? _value.isMilestone
            : isMilestone // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        rolledOver: null == rolledOver
            ? _value.rolledOver
            : rolledOver // ignore: cast_nullable_to_non_nullable
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
class _$GoalModelImpl extends _GoalModel {
  const _$GoalModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.type,
    required this.title,
    this.description,
    @JsonKey(name: 'target_value') this.targetValue,
    @JsonKey(name: 'current_value') this.currentValue = 0,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    @JsonKey(name: 'linked_habits') final List<String> linkedHabits = const [],
    this.phase,
    @JsonKey(name: 'is_milestone') this.isMilestone = false,
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    @JsonKey(name: 'rolled_over') this.rolledOver = false,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _linkedHabits = linkedHabits,
       super._();

  factory _$GoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final GoalType type;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_value')
  final int? targetValue;
  @override
  @JsonKey(name: 'current_value')
  final int currentValue;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final List<String> _linkedHabits;
  @override
  @JsonKey(name: 'linked_habits')
  List<String> get linkedHabits {
    if (_linkedHabits is EqualUnmodifiableListView) return _linkedHabits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_linkedHabits);
  }

  @override
  final int? phase;
  @override
  @JsonKey(name: 'is_milestone')
  final bool isMilestone;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'rolled_over')
  final bool rolledOver;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GoalModel(id: $id, userId: $userId, type: $type, title: $title, description: $description, targetValue: $targetValue, currentValue: $currentValue, startDate: $startDate, endDate: $endDate, linkedHabits: $linkedHabits, phase: $phase, isMilestone: $isMilestone, isCompleted: $isCompleted, rolledOver: $rolledOver, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(
              other._linkedHabits,
              _linkedHabits,
            ) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.isMilestone, isMilestone) ||
                other.isMilestone == isMilestone) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.rolledOver, rolledOver) ||
                other.rolledOver == rolledOver) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    title,
    description,
    targetValue,
    currentValue,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_linkedHabits),
    phase,
    isMilestone,
    isCompleted,
    rolledOver,
    createdAt,
  );

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      __$$GoalModelImplCopyWithImpl<_$GoalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalModelImplToJson(this);
  }
}

abstract class _GoalModel extends GoalModel {
  const factory _GoalModel({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final GoalType type,
    required final String title,
    final String? description,
    @JsonKey(name: 'target_value') final int? targetValue,
    @JsonKey(name: 'current_value') final int currentValue,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'linked_habits') final List<String> linkedHabits,
    final int? phase,
    @JsonKey(name: 'is_milestone') final bool isMilestone,
    @JsonKey(name: 'is_completed') final bool isCompleted,
    @JsonKey(name: 'rolled_over') final bool rolledOver,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$GoalModelImpl;
  const _GoalModel._() : super._();

  factory _GoalModel.fromJson(Map<String, dynamic> json) =
      _$GoalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  GoalType get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_value')
  int? get targetValue;
  @override
  @JsonKey(name: 'current_value')
  int get currentValue;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'linked_habits')
  List<String> get linkedHabits;
  @override
  int? get phase;
  @override
  @JsonKey(name: 'is_milestone')
  bool get isMilestone;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'rolled_over')
  bool get rolledOver;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
