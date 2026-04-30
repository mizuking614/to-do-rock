import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../task/data/task_repository.dart';
import '../../task/domain/task.dart';
import '../../task/domain/task_category.dart';

part 'stats_view_model.g.dart';

enum StatsPeriod { week, month, all }

@riverpod
class StatsViewModel extends _$StatsViewModel {
  @override
  StatsState build() => _compute(StatsPeriod.week);

  StatsState _compute(StatsPeriod period) {
    final repo = ref.read(taskRepositoryProvider);
    final all = repo.getAll();
    final now = DateTime.now();

    DateTime? from;
    if (period == StatsPeriod.week) {
      from = now.subtract(Duration(days: now.weekday - 1));
      from = DateTime(from.year, from.month, from.day);
    } else if (period == StatsPeriod.month) {
      from = DateTime(now.year, now.month, 1);
    }

    List<Task> inPeriod(List<Task> tasks) {
      if (from == null) return tasks;
      return tasks.where((t) {
        final d = t.completedAt ?? t.createdAt;
        return !d.isBefore(from!);
      }).toList();
    }

    final rocks = repo.getRockTasks();
    final pebbles = all.where((t) => t.category == TaskCategory.pebble).toList();
    final sands = all.where((t) => t.category == TaskCategory.sand).toList();

    final periodRocks = inPeriod(rocks);
    final periodPebbles = inPeriod(pebbles);
    final periodSands = inPeriod(sands);

    // Weekly rock completions (Mon=0..Sun=6)
    final weeklyRock = List<int>.filled(7, 0);
    final monday = now.subtract(Duration(days: now.weekday - 1));
    for (final t in rocks.where((t) => t.isDone && t.completedAt != null)) {
      final diff = t.completedAt!.difference(
          DateTime(monday.year, monday.month, monday.day)).inDays;
      if (diff >= 0 && diff < 7) weeklyRock[diff]++;
    }

    // Streak (consecutive days with at least 1 Rock completed)
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final hasRock = rocks.any((t) =>
          t.isDone &&
          t.completedAt != null &&
          t.completedAt!.year == day.year &&
          t.completedAt!.month == day.month &&
          t.completedAt!.day == day.day);
      if (hasRock) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return StatsState(
      period: period,
      completedRock: periodRocks.where((t) => t.isDone).length,
      totalRock: periodRocks.length,
      completedPebble: periodPebbles.where((t) => t.isDone).length,
      totalPebble: periodPebbles.length,
      completedSand: periodSands.where((t) => t.isDone).length,
      totalSand: periodSands.length,
      weeklyRockCompletions: weeklyRock,
      rockStreak: streak,
    );
  }

  void setPeriod(StatsPeriod p) => state = _compute(p);
}

class StatsState {
  const StatsState({
    this.period = StatsPeriod.week,
    this.completedRock = 0,
    this.totalRock = 0,
    this.completedPebble = 0,
    this.totalPebble = 0,
    this.completedSand = 0,
    this.totalSand = 0,
    this.weeklyRockCompletions = const [0, 0, 0, 0, 0, 0, 0],
    this.rockStreak = 0,
  });

  final StatsPeriod period;
  final int completedRock, totalRock;
  final int completedPebble, totalPebble;
  final int completedSand, totalSand;
  final List<int> weeklyRockCompletions;
  final int rockStreak;

  String get advice {
    if (totalRock == 0) return 'Rockタスクを追加してみましょう！';
    if (completedRock == totalRock) return '🎉 今期のRockを全部攻略しました！';
    if (completedRock == 0) return 'まずRockを1つ完了させましょう💪';
    final rate = completedRock / totalRock;
    if (rate >= 0.6) return 'Rockを順調に攻略できています！この調子で！🔥';
    return 'Rockをコツコツ進めましょう。Sand/Pebbleより先に！';
  }
}
