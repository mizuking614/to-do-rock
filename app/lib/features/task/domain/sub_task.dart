import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_task.freezed.dart';
part 'sub_task.g.dart';

@freezed
class SubTask with _$SubTask {
  const factory SubTask({
    required String id,
    required String title,
    @Default(false) bool isDone,
  }) = _SubTask;

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);
}
