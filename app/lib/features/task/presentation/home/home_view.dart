import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';
import 'home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // 画面復帰時にリロード
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _SummaryCard(state: state),
            _FilterTabs(
              selected: state.filter,
              onSelected: (f) =>
                  ref.read(homeViewModelProvider.notifier).setFilter(f),
            ),
            Expanded(
              child: _TaskList(state: state),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/task/create');
          ref.read(homeViewModelProvider.notifier).reload();
        },
        tooltip: 'タスクを追加',
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (i) {
          if (i == 1) context.go('/calendar');
          if (i == 2) context.go('/stats');
        },
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'ホーム'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded), label: 'カレンダー'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: '統計'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primaryLight, AppColors.accent],
            ).createShader(bounds),
            child: const Text(
              'to do rock',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          _IconButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _IconButton(
            icon: Icons.settings_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final total = state.totalRockCount;
    final done = state.completedRockCount;
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a1040), Color(0xFF2d1b69)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.rockBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔒 ROCK 進捗',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '今日のRock',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                total == 0 ? 'タスクなし' : '#$done / $total',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Badge(
                emoji: '🪨',
                value: '${state.pebbleTasks.length}',
                label: 'Pebble残',
              ),
              const SizedBox(width: 8),
              _Badge(
                emoji: '🏖️',
                value: '${state.sandTasks.length}',
                label: 'Sand残',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.emoji, required this.value, required this.label});
  final String emoji, value, label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: AppColors.textDisabled),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Tabs ──────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selected, required this.onSelected});
  final HomeFilter selected;
  final ValueChanged<HomeFilter> onSelected;

  static const _labels = {
    HomeFilter.all: 'すべて',
    HomeFilter.rock: '🔒 Rock',
    HomeFilter.pebble: '🪨 Pebble',
    HomeFilter.sand: '🏖️ Sand',
    HomeFilter.completed: '完了済み',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: HomeFilter.values.map((f) {
          final isActive = f == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(f),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isActive
                        ? Colors.transparent
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  _labels[f]!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Colors.white
                        : AppColors.textDisabled,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Task List ────────────────────────────────────────────────────────────────

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.state});
  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
      children: [
        if (state.filter == HomeFilter.all ||
            state.filter == HomeFilter.rock) ...[
          if (state.rockTasks.isNotEmpty) ...[
            _SectionHeader(
              emoji: '🔒',
              title: 'Rock',
              badgeLabel: '順番制',
              badgeColor: AppColors.rock,
            ),
            ...state.rockTasks.map(
              (t) => _RockTaskCard(
                task: t,
                isActive: state.isRockActive(t),
                isLocked: state.isRockLocked(t),
                onComplete: () =>
                    ref.read(homeViewModelProvider.notifier).completeTask(t.id),
                onTap: () async {
                  await context.push('/task/${t.id}');
                  ref.read(homeViewModelProvider.notifier).reload();
                },
              ),
            ),
            const SizedBox(height: 18),
          ],
        ],
        if (state.filter == HomeFilter.all ||
            state.filter == HomeFilter.pebble) ...[
          if (state.pebbleTasks.isNotEmpty) ...[
            _SectionHeader(
              emoji: '🪨',
              title: 'Pebble',
              badgeLabel: '自由順',
              badgeColor: AppColors.pebble,
            ),
            ...state.pebbleTasks.map(
              (t) => _FreeTaskCard(
                task: t,
                category: TaskCategory.pebble,
                onComplete: () =>
                    ref.read(homeViewModelProvider.notifier).completeTask(t.id),
                onTap: () async {
                  await context.push('/task/${t.id}');
                  ref.read(homeViewModelProvider.notifier).reload();
                },
              ),
            ),
            const SizedBox(height: 18),
          ],
        ],
        if (state.filter == HomeFilter.all ||
            state.filter == HomeFilter.sand) ...[
          if (state.sandTasks.isNotEmpty) ...[
            _SectionHeader(
              emoji: '🏖️',
              title: 'Sand',
              badgeLabel: '自由順',
              badgeColor: AppColors.sand,
            ),
            ...state.sandTasks.map(
              (t) => _FreeTaskCard(
                task: t,
                category: TaskCategory.sand,
                onComplete: () =>
                    ref.read(homeViewModelProvider.notifier).completeTask(t.id),
                onTap: () async {
                  await context.push('/task/${t.id}');
                  ref.read(homeViewModelProvider.notifier).reload();
                },
              ),
            ),
            const SizedBox(height: 18),
          ],
        ],
        if (state.filter == HomeFilter.completed) ...[
          if (state.completedTasks.isNotEmpty) ...[
            _SectionHeader(
              emoji: '✅',
              title: '完了済み',
              badgeLabel: '${state.completedTasks.length}件',
              badgeColor: AppColors.success,
            ),
            ...state.completedTasks.map(
              (t) => _CompletedTaskCard(
                task: t,
                onUncomplete: () =>
                    ref.read(homeViewModelProvider.notifier).uncompleteTask(t.id),
              ),
            ),
          ] else
            const _EmptyMessage(message: '完了済みのタスクはありません'),
        ],
        if (state.filter != HomeFilter.completed &&
            state.rockTasks.isEmpty &&
            state.pebbleTasks.isEmpty &&
            state.sandTasks.isEmpty)
          const _EmptyMessage(message: 'タスクがありません\n＋ボタンで追加しましょう！'),
      ],
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.emoji,
    required this.title,
    required this.badgeLabel,
    required this.badgeColor,
  });
  final String emoji, title, badgeLabel;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '$emoji $title',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDisabled,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rock Task Card ───────────────────────────────────────────────────────────

class _RockTaskCard extends StatelessWidget {
  const _RockTaskCard({
    required this.task,
    required this.isActive,
    required this.isLocked,
    required this.onComplete,
    required this.onTap,
  });
  final Task task;
  final bool isActive, isLocked;
  final VoidCallback onComplete, onTap;

  @override
  Widget build(BuildContext context) {
    final isDone = task.isDone;

    return GestureDetector(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('前のタスクを完了してから進めます 🔒'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          : onTap,
      child: AnimatedOpacity(
        opacity: isLocked ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF1a1040)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppColors.rockBorder
                  : AppColors.border,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                    )
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: isDone || isLocked ? null : onComplete,
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.primary
                        : isActive
                            ? Colors.transparent
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: isDone
                          ? AppColors.primary
                          : isActive
                              ? AppColors.primary
                              : AppColors.textMuted,
                      width: 2,
                    ),
                    boxShadow: isActive && !isDone
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${(task.rockOrder ?? 0) + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isDone
                                ? AppColors.textMuted
                                : AppColors.primary,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.rockBg,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: AppColors.rockBorder),
                            ),
                            child: const Text(
                              '▶ 今ここ',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.rock,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDone || isLocked
                            ? AppColors.textDisabled
                            : AppColors.textPrimary,
                        decoration:
                            isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 5),
                      _DueDateChip(dueDate: task.dueDate!),
                    ],
                  ],
                ),
              ),
              if (isLocked)
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 2),
                  child: Text('🔒', style: TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Free Task Card (Pebble / Sand) ──────────────────────────────────────────

class _FreeTaskCard extends StatelessWidget {
  const _FreeTaskCard({
    required this.task,
    required this.category,
    required this.onComplete,
    required this.onTap,
  });
  final Task task;
  final TaskCategory category;
  final VoidCallback onComplete, onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onComplete,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: AppColors.textMuted, width: 2),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 4),
                    _DueDateChip(dueDate: task.dueDate!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Completed Task Card ──────────────────────────────────────────────────────

class _CompletedTaskCard extends StatelessWidget {
  const _CompletedTaskCard({required this.task, required this.onUncomplete});
  final Task task;
  final VoidCallback onUncomplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onUncomplete,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textDisabled,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: task.category == TaskCategory.rock
                  ? AppColors.rockBg
                  : task.category == TaskCategory.pebble
                      ? AppColors.pebbleBg
                      : AppColors.sandBg,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              task.category.emoji,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Due Date Chip ────────────────────────────────────────────────────────────

class _DueDateChip extends StatelessWidget {
  const _DueDateChip({required this.dueDate});
  final DateTime dueDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(DateTime(now.year, now.month, now.day));
    final isToday = dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;

    String label;
    if (isToday) {
      label = '⏰ 今日まで';
    } else if (isOverdue) {
      label = '🔴 期限切れ';
    } else {
      label = '📅 ${dueDate.month}/${dueDate.day}';
    }

    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        color: isOverdue ? AppColors.danger : AppColors.textDisabled,
      ),
    );
  }
}

// ─── Empty Message ────────────────────────────────────────────────────────────

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textDisabled,
            fontSize: 14,
            height: 1.8,
          ),
        ),
      ),
    );
  }
}

// ─── Icon Button ──────────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
