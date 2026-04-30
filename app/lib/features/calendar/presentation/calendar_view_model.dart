import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../task/data/task_repository.dart';
import '../../task/domain/task.dart';

part 'calendar_view_model.g.dart';

@riverpod
class CalendarViewModel extends _$CalendarViewModel {
  @override
  CalendarState build() {
    final now = DateTime.now();
    return _load(
      month: DateTime(now.year, now.month),
      selected: DateTime(now.year, now.month, now.day),
    );
  }

  CalendarState _load({required DateTime month, required DateTime selected}) {
    final repo = ref.read(taskRepositoryProvider);
    final all = repo.getAll();
    final activeOrder = repo.getCurrentRockIndex();

    final Map<String, List<Task>> byDate = {};
    for (final t in all) {
      final d = t.dueDate;
      if (d == null) continue;
      final key = _key(d);
      byDate.putIfAbsent(key, () => []).add(t);
    }

    final selectedTasks = byDate[_key(selected)] ?? [];

    return CalendarState(
      focusedMonth: month,
      selectedDate: selected,
      tasksByDate: byDate,
      selectedTasks: selectedTasks,
      currentRockOrder: activeOrder,
    );
  }

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void selectDate(DateTime date) =>
      state = _load(month: state.focusedMonth, selected: date);

  void prevMonth() {
    final m = state.focusedMonth;
    state = _load(
      month: DateTime(m.year, m.month - 1),
      selected: state.selectedDate,
    );
  }

  void nextMonth() {
    final m = state.focusedMonth;
    state = _load(
      month: DateTime(m.year, m.month + 1),
      selected: state.selectedDate,
    );
  }

  void goToToday() {
    final now = DateTime.now();
    state = _load(
      month: DateTime(now.year, now.month),
      selected: DateTime(now.year, now.month, now.day),
    );
  }
}

class CalendarState {
  CalendarState({
    required this.focusedMonth,
    required this.selectedDate,
    this.tasksByDate = const {},
    this.selectedTasks = const [],
    this.currentRockOrder = -1,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<String, List<Task>> tasksByDate;
  final List<Task> selectedTasks;
  final int currentRockOrder;

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<Task>? tasksForDate(DateTime d) => tasksByDate[_key(d)];
}
