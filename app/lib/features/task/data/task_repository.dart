import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/task.dart';
import '../domain/task_category.dart';
import '../domain/sub_task.dart';

part 'task_repository.g.dart';

const _boxName = 'tasks';

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepository();
}

class TaskRepository {
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  // ---- Read ----

  /// アーカイブ済みを除いた全タスク（通常の操作に使用）
  List<Task> getAll() {
    return _box.values
        .map((json) => Task.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .where((t) => !t.isArchived)
        .toList();
  }

  /// アーカイブ済みも含む全タスク（統計に使用）
  List<Task> getAllIncludingArchived() {
    return _box.values
        .map((json) => Task.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  List<Task> getRockTasks() {
    final rocks = getAll()
        .where((t) => t.category == TaskCategory.rock)
        .toList()
      ..sort((a, b) => (a.rockOrder ?? 0).compareTo(b.rockOrder ?? 0));
    return rocks;
  }

  List<Task> getPebbleTasks() {
    return getAll()
        .where((t) => t.category == TaskCategory.pebble && !t.isDone)
        .toList();
  }

  List<Task> getSandTasks() {
    return getAll()
        .where((t) => t.category == TaskCategory.sand && !t.isDone)
        .toList();
  }

  /// 現在アクティブなRockタスクのインデックス（未完了の最小rockOrder）
  int getCurrentRockIndex() {
    final rocks = getRockTasks().where((t) => !t.isDone).toList();
    if (rocks.isEmpty) return -1;
    return rocks.first.rockOrder ?? 0;
  }

  // ---- Write ----

  Future<Task> createTask({
    required String title,
    required TaskCategory category,
    String memo = '',
    DateTime? dueDate,
    List<SubTask> subTasks = const [],
    bool isRepeating = false,
  }) async {
    int? rockOrder;
    if (category == TaskCategory.rock) {
      final existingRocks = getRockTasks();
      rockOrder = existingRocks.length;
    }

    final task = Task(
      id: const Uuid().v4(),
      title: title,
      category: category,
      rockOrder: rockOrder,
      memo: memo,
      dueDate: dueDate,
      subTasks: subTasks,
      isRepeating: isRepeating,
      createdAt: DateTime.now(),
    );

    await _box.put(task.id, jsonEncode(task.toJson()));
    return task;
  }

  Future<void> updateTask(Task task) async {
    await _box.put(task.id, jsonEncode(task.toJson()));
  }

  /// 物理削除（データも統計からも完全に消える）
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
    // Rockの場合は順番を詰め直す
    final rocks = getRockTasks();
    for (var i = 0; i < rocks.length; i++) {
      final updated = rocks[i].copyWith(rockOrder: i);
      await _box.put(updated.id, jsonEncode(updated.toJson()));
    }
  }

  /// アーカイブ（一覧から非表示にするが統計には残る）
  Future<void> archiveTask(String id) async {
    final all = getAllIncludingArchived();
    final task = all.firstWhere((t) => t.id == id);
    final archived = task.copyWith(isArchived: true);
    await _box.put(archived.id, jsonEncode(archived.toJson()));
  }

  Future<Task> completeTask(String id) async {
    final all = getAll();
    final task = all.firstWhere((t) => t.id == id);
    final updated = task.copyWith(
      isDone: true,
      completedAt: DateTime.now(),
    );
    await updateTask(updated);
    return updated;
  }

  Future<Task> uncompleteTask(String id) async {
    final all = getAll();
    final task = all.firstWhere((t) => t.id == id);
    final updated = task.copyWith(isDone: false, completedAt: null);
    await updateTask(updated);
    return updated;
  }

  /// Rockタスクの順番を並び替える（受け取ったリストの順番でrockOrderを振り直す）
  Future<void> reorderRockTasks(List<Task> reordered) async {
    for (var i = 0; i < reordered.length; i++) {
      final updated = reordered[i].copyWith(rockOrder: i);
      await _box.put(updated.id, jsonEncode(updated.toJson()));
    }
  }
}
