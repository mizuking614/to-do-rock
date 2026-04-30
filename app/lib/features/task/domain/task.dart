import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_category.dart';
import 'sub_task.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required TaskCategory category,
    @Default(false) bool isDone,
    /// Rock のみ: リスト内の順番（0始まり）
    int? rockOrder,
    DateTime? dueDate,
    @Default('') String memo,
    @Default([]) List<SubTask> subTasks,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default(false) bool isRepeating,
    /// 完了済みを一覧から非表示にする（統計には残る）
    @Default(false) bool isArchived,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
