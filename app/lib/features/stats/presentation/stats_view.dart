import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'stats_view_model.dart';

class StatsView extends ConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statsViewModelProvider);
    final vm = ref.read(statsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  const Text('📊 統計', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const Spacer(),
                  TextButton(onPressed: () => context.go('/'), child: const Text('ホーム', style: TextStyle(color: AppColors.primaryLight))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Period tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: StatsPeriod.values.map((p) {
                  final isActive = state.period == p;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => vm.setPeriod(p),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(
                          _periodLabel(p),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.textDisabled),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Streak card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1a1040), Color(0xFF2d1b69)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.rockBorder),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${state.rockStreak}日', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            const Text('Rock連続達成', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${state.completedRock}/${state.totalRock}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryLight)),
                            const Text('Rock完了', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weekly chart
                  const Text('今週のRock完了数', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDisabled, letterSpacing: 0.8)),
                  const SizedBox(height: 12),
                  _WeeklyChart(data: state.weeklyRockCompletions),
                  const SizedBox(height: 20),

                  // Category stats
                  const Text('カテゴリ別', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDisabled, letterSpacing: 0.8)),
                  const SizedBox(height: 12),
                  _CategoryStatCard(
                    emoji: '🔒', label: 'Rock',
                    completed: state.completedRock, total: state.totalRock,
                    color: AppColors.rock, bgColor: AppColors.rockBg, borderColor: AppColors.rockBorder,
                  ),
                  const SizedBox(height: 8),
                  _CategoryStatCard(
                    emoji: '🪨', label: 'Pebble',
                    completed: state.completedPebble, total: state.totalPebble,
                    color: AppColors.pebble, bgColor: AppColors.pebbleBg, borderColor: AppColors.pebbleBorder,
                  ),
                  const SizedBox(height: 8),
                  _CategoryStatCard(
                    emoji: '🏖️', label: 'Sand',
                    completed: state.completedSand, total: state.totalSand,
                    color: AppColors.sand, bgColor: AppColors.sandBg, borderColor: AppColors.sandBorder,
                  ),
                  const SizedBox(height: 20),

                  // Advice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(state.advice, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (i) {
          if (i == 0) context.go('/');
          if (i == 1) context.go('/calendar');
        },
        selectedIndex: 2,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'カレンダー'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: '統計'),
        ],
      ),
    );
  }

  String _periodLabel(StatsPeriod p) => switch (p) {
    StatsPeriod.week => '今週',
    StatsPeriod.month => '今月',
    StatsPeriod.all => '全期間',
  };
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.data});
  final List<int> data;

  static const _days = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    final maxVal = data.fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final val = data[i];
          final ratio = (maxVal == 0) ? 0.0 : val / maxVal;
          final isToday = i == (DateTime.now().weekday - 1);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                children: [
                  if (val > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('$val', style: const TextStyle(fontSize: 9, color: AppColors.primaryLight, fontWeight: FontWeight.w700)),
                    ),
                  Container(
                    height: 60 * ratio + 4,
                    decoration: BoxDecoration(
                      gradient: val > 0
                          ? const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [AppColors.primary, AppColors.primaryLight])
                          : null,
                      color: val == 0 ? AppColors.surfaceVariant : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday ? AppColors.primaryLight : AppColors.textDisabled,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryStatCard extends StatelessWidget {
  const _CategoryStatCard({
    required this.emoji, required this.label,
    required this.completed, required this.total,
    required this.color, required this.bgColor, required this.borderColor,
  });
  final String emoji, label;
  final int completed, total;
  final Color color, bgColor, borderColor;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text('$completed / $total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: Colors.white.withValues(alpha: 0.08), valueColor: AlwaysStoppedAnimation<Color>(color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
