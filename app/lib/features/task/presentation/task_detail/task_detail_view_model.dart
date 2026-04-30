import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/task_repository.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';

part 'task_detail_view_model.g.dart';

@riverpod
class TaskDetailViewModel extends _$TaskDetailViewModel {
  @override
  TaskDetailState build({required String taskId}) {
    return _load(taskId);
  }

  TaskDetailState _load(String taskId) {
    final repo = ref.read(taskRepositoryProvider);
    final all = repo.getAll();
    try {
      final task = all.firstWhere((t) => t.id == taskId);
      final activeOrder = repo.getCurrentRockIndex();
      final isLocked = task.category == TaskCategory.rock &&
          !task.isDone &&
          (task.rockOrder ?? 0) > activeOrder;
      return TaskDetailState(task: task, isLocked: isLocked);
    } catch (_) {
      return const TaskDetailState();
    }
  }

  Future<void> completeTask() async {
    final task = state.task;
    if (task == null || state.isLocked) return;
    final repo = ref.read(taskRepositoryProvider);
    await repo.completeTask(task.id);
    state = _load(task.id);
  }

  Future<void> toggleSubTask(String subTaskId) async {
    final task = state.task;
    if (task == null || state.isLocked) return;
    final repo = ref.read(taskRepositoryProvider);
    final updated = task.copyWith(
      subTasks: task.subTasks
          .map((s) => s.id == subTaskId ? s.copyWith(isDone: !s.isDone) : s)
          .toList(),
    );
    await repo.updateTask(updated);
    state = _load(task.id);
  }

  Future<void> deleteTask() async {
    final task = state.task;
    if (task == null) return;
    final repo = ref.read(taskRepositoryProvider);
    await repo.deleteTask(task.id);
  }
}

class TaskDetailState {
  const TaskDetailState({
    this.task,
    this.isLocked = false,
  });

  final Task? task;
  final bool isLocked;
}
