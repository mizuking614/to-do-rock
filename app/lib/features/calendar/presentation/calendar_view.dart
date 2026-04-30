import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../task/domain/task.dart';
import '../../task/domain/task_category.dart';
import 'calendar_view_model.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarViewModelProvider);
    final vm = ref.read(calendarViewModelProvider.notifier);
    final m = state.focusedMonth;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  const Text('📅 カレンダー', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const Spacer(),
                  TextButton(onPressed: vm.goToToday, child: const Text('今日', style: TextStyle(color: AppColors.primaryLight))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: vm.prevMonth,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                      child: const Icon(Icons.chevron_left_rounded, size: 20, color: AppColors.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${m.year}年${m.month}月',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ),
                  GestureDetector(
                    onTap: vm.nextMonth,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                      child: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Weekday labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: ['月', '火', '水', '木', '金', '土', '日'].map((d) => Expanded(
                  child: Text(d, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textDisabled, fontWeight: FontWeight.w600)),
                )).toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CalendarGrid(state: state, onDateTap: vm.selectDate),
            ),
            const SizedBox(height: 16),
            // Selected day tasks
            Expanded(
              child: _SelectedDayTasks(state: state),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (i) {
          if (i == 0) context.go('/');
          if (i == 2) context.go('/stats');
        },
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'カレンダー'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: '統計'),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.state, required this.onDateTap});
  final CalendarState state;
  final ValueChanged<DateTime> onDateTap;

  @override
  Widget build(BuildContext context) {
    final m = state.focusedMonth;
    // First day of month (weekday: Mon=1..Sun=7)
    final firstDay = DateTime(m.year, m.month, 1);
    final startOffset = (firstDay.weekday - 1); // Mon=0
    final daysInMonth = DateTime(m.year, m.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final now = DateTime.now();

    return Column(
      children: List.generate(rows, (row) => Row(
        children: List.generate(7, (col) {
          final cellIndex = row * 7 + col;
          final dayNum = cellIndex - startOffset + 1;
          if (dayNum < 1 || dayNum > daysInMonth) {
            return const Expanded(child: SizedBox(height: 44));
          }
          final date = DateTime(m.year, m.month, dayNum);
          final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
          final isSelected = date.year == state.selectedDate.year && date.month == state.selectedDate.month && date.day == state.selectedDate.day;
          final tasks = state.tasksForDate(date);
          final hasTasks = tasks != null && tasks.isNotEmpty;

          return Expanded(
            child: GestureDetector(
              onTap: () => onDateTap(date),
              child: Container(
                height: 44,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : isToday ? AppColors.rockBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday && !isSelected ? Border.all(color: AppColors.rockBorder) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? Colors.white : isToday ? AppColors.primaryLight : AppColors.textSecondary,
                      ),
                    ),
                    if (hasTasks)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tasks.take(3).map((t) {
                            final color = switch (t.category) {
                              TaskCategory.rock => AppColors.rock,
                              TaskCategory.pebble => AppColors.pebble,
                              TaskCategory.sand => AppColors.sand,
                            };
                            return Container(
                              width: 4, height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      )),
    );
  }
}

class _SelectedDayTasks extends StatelessWidget {
  const _SelectedDayTasks({required this.state});
  final CalendarState state;

  @override
  Widget build(BuildContext context) {
    final d = state.selectedDate;
    final label = '${d.month}月${d.day}日';
    final tasks = state.selectedTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
          child: Text(
            '$label のタスク',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDisabled, letterSpacing: 0.5),
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? const Center(child: Text('タスクなし', style: TextStyle(color: AppColors.textDisabled, fontSize: 13)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: tasks.length,
                  itemBuilder: (_, i) => _CalendarTaskCard(task: tasks[i]),
                ),
        ),
      ],
    );
  }
}

class _CalendarTaskCard extends StatelessWidget {
  const _CalendarTaskCard({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    final (color, bg, border) = switch (task.category) {
      TaskCategory.rock => (AppColors.rock, AppColors.rockBg, AppColors.rockBorder),
      TaskCategory.pebble => (AppColors.pebble, AppColors.pebbleBg, AppColors.pebbleBorder),
      TaskCategory.sand => (AppColors.sand, AppColors.sandBg, AppColors.sandBorder),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(task.title, style: TextStyle(fontSize: 14, color: task.isDone ? AppColors.textDisabled : AppColors.textPrimary, decoration: task.isDone ? TextDecoration.lineThrough : null)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99), border: Border.all(color: border)),
            child: Text(task.category.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }
}
