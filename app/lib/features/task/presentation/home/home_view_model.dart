import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/task_repository.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';

part 'home_view_model.g.dart';

enum HomeFilter { all, rock, pebble, sand, completed }

// ─── State ───────────────────────────────────────────────────────────────────

class HomeState {
  const HomeState({
    this.rockTasks = const [],
    this.pebbleTasks = const [],
    this.sandTasks = const [],
    this.completedTasks = const [],
    this.filter = HomeFilter.all,
    this.isLoading = false,
  });

  final List<Task> rockTasks;
  final List<Task> pebbleTasks;
  final List<Task> sandTasks;
  final List<Task> completedTasks;
  final HomeFilter filter;
  final bool isLoading;

  /// 現在アクティブな Rock の rockOrder（未完了の最小番号）
  int get currentRockOrder {
    final active = rockTasks.where((t) => !t.isDone).toList();
    if (active.isEmpty) return -1;
    return active.first.rockOrder ?? 0;
  }

  bool isRockActive(Task task) =>
      task.category == TaskCategory.rock &&
      !task.isDone &&
      (task.rockOrder ?? 0) == currentRockOrder;

  bool isRockLocked(Task task) =>
      task.category == TaskCategory.rock &&
      !task.isDone &&
      (task.rockOrder ?? 0) > currentRockOrder;

  int get completedRockCount => rockTasks.where((t) => t.isDone).length;
  int get totalRockCount => rockTasks.length;

  HomeState copyWith({
    List<Task>? rockTasks,
    List<Task>? pebbleTasks,
    List<Task>? sandTasks,
    List<Task>? completedTasks,
    HomeFilter? filter,
    bool? isLoading,
  }) {
    return HomeState(
      rockTasks: rockTasks ?? this.rockTasks,
      pebbleTasks: pebbleTasks ?? this.pebbleTasks,
      sandTasks: sandTasks ?? this.sandTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── ViewModel ───────────────────────────────────────────────────────────────

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    return _loadState(const HomeState());
  }

  HomeState _loadState(HomeState current) {
    final repo = ref.read(taskRepositoryProvider);
    final all = repo.getAll();
    return current.copyWith(
      rockTasks: repo.getRockTasks(),
      pebbleTasks: repo.getPebbleTasks(),
      sandTasks: repo.getSandTasks(),
      completedTasks: all.where((t) => t.isDone).toList()
        ..sort((a, b) =>
            (b.completedAt ?? DateTime(0)).compareTo(a.completedAt ?? DateTime(0))),
      isLoading: false,
    );
  }

  void reload() {
    state = _loadState(state);
  }

  void setFilter(HomeFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> completeTask(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.completeTask(id);
    state = _loadState(state);
  }

  Future<void> uncompleteTask(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.uncompleteTask(id);
    state = _loadState(state);
  }

  Future<void> deleteTask(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.deleteTask(id);
    state = _loadState(state);
  }

  Future<void> reorderRockTasks(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final rocks = List<Task>.from(state.rockTasks);
    final item = rocks.removeAt(oldIndex);
    rocks.insert(newIndex, item);
    
    // 即座にUIに反映させる
    state = state.copyWith(rockTasks: rocks);
    
    // バックグラウンドで永続化
    final repo = ref.read(taskRepositoryProvider);
    await repo.reorderRockTasks(rocks);
    // 保存後に正規化されたデータを再読み込み
    state = _loadState(state);
  }

  /// 完了済みタスクをアーカイブ（一覧から消えるが統計に残る）
  Future<void> archiveTask(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.archiveTask(id);
    state = _loadState(state);
  }
}
