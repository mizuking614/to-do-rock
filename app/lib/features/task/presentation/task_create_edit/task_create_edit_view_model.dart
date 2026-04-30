import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/task_repository.dart';
import '../../domain/task_category.dart';
import '../../domain/sub_task.dart';

part 'task_create_edit_view_model.g.dart';

@riverpod
class TaskCreateEditViewModel extends _$TaskCreateEditViewModel {
  @override
  TaskCreateEditState build({String? taskId}) {
    if (taskId != null) {
      final repo = ref.read(taskRepositoryProvider);
      final all = repo.getAll();
      final task = all.firstWhere((t) => t.id == taskId);
      return TaskCreateEditState(
        isEditMode: true,
        taskId: taskId,
        category: task.category,
        title: task.title,
        memo: task.memo,
        dueDate: task.dueDate,
        subTasks: task.subTasks,
        rockOrder: task.rockOrder,
        isRepeating: task.isRepeating,
        nextRockPosition: _getNextRockPosition(),
      );
    }
    return TaskCreateEditState(
      nextRockPosition: _getNextRockPosition(),
    );
  }

  int _getNextRockPosition() {
    final repo = ref.read(taskRepositoryProvider);
    return repo.getRockTasks().length;
  }

  void setCategory(TaskCategory c) =>
      state = state.copyWith(category: c);

  void setTitle(String v) => state = state.copyWith(title: v);

  void setMemo(String v) => state = state.copyWith(memo: v);

  void setDueDate(DateTime? d) => state = state.copyWith(dueDate: d, hasDueDate: d != null);

  void toggleDueDate(bool v) {
    state = state.copyWith(
      hasDueDate: v,
      dueDate: v ? (state.dueDate ?? DateTime.now().add(const Duration(days: 1))) : null,
    );
  }

  void addSubTask(String title) {
    if (title.trim().isEmpty) return;
    final sub = SubTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    state = state.copyWith(subTasks: [...state.subTasks, sub]);
  }

  void removeSubTask(String id) {
    state = state.copyWith(subTasks: state.subTasks.where((s) => s.id != id).toList());
  }

  void toggleSubTask(String id) {
    state = state.copyWith(
      subTasks: state.subTasks
          .map((s) => s.id == id ? s.copyWith(isDone: !s.isDone) : s)
          .toList(),
    );
  }

  Future<bool> save() async {
    if (state.title.trim().isEmpty) return false;
    final repo = ref.read(taskRepositoryProvider);
    if (state.isEditMode && state.taskId != null) {
      final all = repo.getAll();
      final task = all.firstWhere((t) => t.id == state.taskId);
      await repo.updateTask(task.copyWith(
        title: state.title.trim(),
        category: state.category,
        memo: state.memo,
        dueDate: state.dueDate,
        subTasks: state.subTasks,
        isRepeating: state.isRepeating,
      ));
    } else {
      await repo.createTask(
        title: state.title.trim(),
        category: state.category,
        memo: state.memo,
        dueDate: state.dueDate,
        subTasks: state.subTasks,
        isRepeating: state.isRepeating,
      );
    }
    return true;
  }
}

class TaskCreateEditState {
  const TaskCreateEditState({
    this.isEditMode = false,
    this.taskId,
    this.category = TaskCategory.rock,
    this.title = '',
    this.memo = '',
    this.dueDate,
    this.hasDueDate = false,
    this.subTasks = const [],
    this.rockOrder,
    this.isRepeating = false,
    this.nextRockPosition = 0,
  });

  final bool isEditMode;
  final String? taskId;
  final TaskCategory category;
  final String title;
  final String memo;
  final DateTime? dueDate;
  final bool hasDueDate;
  final List<SubTask> subTasks;
  final int? rockOrder;
  final bool isRepeating;
  final int nextRockPosition;

  bool get canSave => title.trim().isNotEmpty;

  TaskCreateEditState copyWith({
    bool? isEditMode,
    String? taskId,
    TaskCategory? category,
    String? title,
    String? memo,
    DateTime? dueDate,
    bool? hasDueDate,
    List<SubTask>? subTasks,
    int? rockOrder,
    bool? isRepeating,
    int? nextRockPosition,
  }) => TaskCreateEditState(
    isEditMode: isEditMode ?? this.isEditMode,
    taskId: taskId ?? this.taskId,
    category: category ?? this.category,
    title: title ?? this.title,
    memo: memo ?? this.memo,
    dueDate: dueDate ?? this.dueDate,
    hasDueDate: hasDueDate ?? this.hasDueDate,
    subTasks: subTasks ?? this.subTasks,
    rockOrder: rockOrder ?? this.rockOrder,
    isRepeating: isRepeating ?? this.isRepeating,
    nextRockPosition: nextRockPosition ?? this.nextRockPosition,
  );
}
