// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  TaskCategory get category => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;

  /// Rock のみ: リスト内の順番（0始まり）
  int? get rockOrder => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  List<SubTask> get subTasks => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isRepeating => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    String id,
    String title,
    TaskCategory category,
    bool isDone,
    int? rockOrder,
    DateTime? dueDate,
    String memo,
    List<SubTask> subTasks,
    DateTime createdAt,
    DateTime? completedAt,
    bool isRepeating,
  });
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? isDone = null,
    Object? rockOrder = freezed,
    Object? dueDate = freezed,
    Object? memo = null,
    Object? subTasks = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? isRepeating = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TaskCategory,
            isDone: null == isDone
                ? _value.isDone
                : isDone // ignore: cast_nullable_to_non_nullable
                      as bool,
            rockOrder: freezed == rockOrder
                ? _value.rockOrder
                : rockOrder // ignore: cast_nullable_to_non_nullable
                      as int?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            memo: null == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String,
            subTasks: null == subTasks
                ? _value.subTasks
                : subTasks // ignore: cast_nullable_to_non_nullable
                      as List<SubTask>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isRepeating: null == isRepeating
                ? _value.isRepeating
                : isRepeating // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    TaskCategory category,
    bool isDone,
    int? rockOrder,
    DateTime? dueDate,
    String memo,
    List<SubTask> subTasks,
    DateTime createdAt,
    DateTime? completedAt,
    bool isRepeating,
  });
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? isDone = null,
    Object? rockOrder = freezed,
    Object? dueDate = freezed,
    Object? memo = null,
    Object? subTasks = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? isRepeating = null,
  }) {
    return _then(
      _$TaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TaskCategory,
        isDone: null == isDone
            ? _value.isDone
            : isDone // ignore: cast_nullable_to_non_nullable
                  as bool,
        rockOrder: freezed == rockOrder
            ? _value.rockOrder
            : rockOrder // ignore: cast_nullable_to_non_nullable
                  as int?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        memo: null == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String,
        subTasks: null == subTasks
            ? _value._subTasks
            : subTasks // ignore: cast_nullable_to_non_nullable
                  as List<SubTask>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isRepeating: null == isRepeating
            ? _value.isRepeating
            : isRepeating // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    required this.id,
    required this.title,
    required this.category,
    this.isDone = false,
    this.rockOrder,
    this.dueDate,
    this.memo = '',
    final List<SubTask> subTasks = const [],
    required this.createdAt,
    this.completedAt,
    this.isRepeating = false,
  }) : _subTasks = subTasks;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final TaskCategory category;
  @override
  @JsonKey()
  final bool isDone;

  /// Rock のみ: リスト内の順番（0始まり）
  @override
  final int? rockOrder;
  @override
  final DateTime? dueDate;
  @override
  @JsonKey()
  final String memo;
  final List<SubTask> _subTasks;
  @override
  @JsonKey()
  List<SubTask> get subTasks {
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTasks);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isRepeating;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, category: $category, isDone: $isDone, rockOrder: $rockOrder, dueDate: $dueDate, memo: $memo, subTasks: $subTasks, createdAt: $createdAt, completedAt: $completedAt, isRepeating: $isRepeating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.rockOrder, rockOrder) ||
                other.rockOrder == rockOrder) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isRepeating, isRepeating) ||
                other.isRepeating == isRepeating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    category,
    isDone,
    rockOrder,
    dueDate,
    memo,
    const DeepCollectionEquality().hash(_subTasks),
    createdAt,
    completedAt,
    isRepeating,
  );

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    required final String id,
    required final String title,
    required final TaskCategory category,
    final bool isDone,
    final int? rockOrder,
    final DateTime? dueDate,
    final String memo,
    final List<SubTask> subTasks,
    required final DateTime createdAt,
    final DateTime? completedAt,
    final bool isRepeating,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  TaskCategory get category;
  @override
  bool get isDone;

  /// Rock のみ: リスト内の順番（0始まり）
  @override
  int? get rockOrder;
  @override
  DateTime? get dueDate;
  @override
  String get memo;
  @override
  List<SubTask> get subTasks;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  bool get isRepeating;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
