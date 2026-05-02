// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  category: $enumDecode(_$TaskCategoryEnumMap, json['category']),
  isDone: json['isDone'] as bool? ?? false,
  rockOrder: (json['rockOrder'] as num?)?.toInt(),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  memo: json['memo'] as String? ?? '',
  subTasks:
      (json['subTasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  isRepeating: json['isRepeating'] as bool? ?? false,
  isArchived: json['isArchived'] as bool? ?? false,
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$TaskCategoryEnumMap[instance.category]!,
      'isDone': instance.isDone,
      'rockOrder': instance.rockOrder,
      'dueDate': instance.dueDate?.toIso8601String(),
      'memo': instance.memo,
      'subTasks': instance.subTasks,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isRepeating': instance.isRepeating,
      'isArchived': instance.isArchived,
    };

const _$TaskCategoryEnumMap = {
  TaskCategory.rock: 'rock',
  TaskCategory.pebble: 'pebble',
  TaskCategory.sand: 'sand',
};
