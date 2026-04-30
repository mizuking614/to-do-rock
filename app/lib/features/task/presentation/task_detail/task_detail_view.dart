import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../task/domain/task_category.dart';
import 'task_detail_view_model.dart';

class TaskDetailView extends ConsumerWidget {
  const TaskDetailView({super.key, required this.taskId});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskDetailViewModelProvider(taskId: taskId));
    final vm = ref.read(taskDetailViewModelProvider(taskId: taskId).notifier);
    final task = state.task;

    if (task == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => context.pop(),
          ),
          title: const Text('タスク詳細'),
        ),
        body: const Center(child: Text('タスクが見つかりません', style: TextStyle(color: AppColors.textDisabled))),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        title: _CategoryBadge(category: task.category),
        actions: [
          if (!task.isDone && !state.isLocked)
            IconButton(
              icon: const Icon(Icons.edit_rounded, size: 18),
              onPressed: () async {
                await context.push('/task/$taskId/edit');
                ref.invalidate(taskDetailViewModelProvider(taskId: taskId));
              },
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 18),
            onSelected: (v) async {
              if (v == 'delete') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surfaceVariant,
                    title: const Text('タスクを削除'),
                    content: const Text('このタスクを削除しますか？'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('キャンセル')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('削除', style: TextStyle(color: AppColors.danger))),
                    ],
                  ),
                );
                if (ok == true) {
                  await vm.deleteTask();
                  if (context.mounted) context.pop();
                }
              }
            },
            itemBuilder: (_) => [const PopupMenuItem(value: 'delete', child: Text('削除'))],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        children: [
          if (state.isLocked) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dangerBorder),
              ),
              child: const Row(
                children: [
                  Text('🔒', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Expanded(child: Text('前のRockタスクを完了してから進めます', style: TextStyle(fontSize: 13, color: AppColors.danger))),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (task.category == TaskCategory.rock && task.rockOrder != null) ...[
            Text('ROCK #${task.rockOrder! + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: task.isDone ? AppColors.textMuted : AppColors.primary, letterSpacing: 1.2)),
            const SizedBox(height: 8),
          ],
          Text(task.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: task.isDone ? AppColors.textDisabled : AppColors.textPrimary, decoration: task.isDone ? TextDecoration.lineThrough : null, height: 1.3)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              if (task.dueDate != null) _Chip(icon: '📅', label: '${task.dueDate!.year}/${task.dueDate!.month}/${task.dueDate!.day}'),
              if (task.isDone && task.completedAt != null) _Chip(icon: '✅', label: '${task.completedAt!.month}/${task.completedAt!.day} 完了', color: AppColors.success),
              _Chip(icon: '📝', label: '${task.createdAt.year}/${task.createdAt.month}/${task.createdAt.day} 作成'),
            ],
          ),
          if (task.memo.isNotEmpty) ...[
            const SizedBox(height: 24),
            const _SectionLabel(text: 'メモ'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Text(task.memo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
            ),
          ],
          if (task.subTasks.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionLabel(text: 'サブタスク (${task.subTasks.where((s) => s.isDone).length}/${task.subTasks.length})'),
            const SizedBox(height: 10),
            ...task.subTasks.map((s) => GestureDetector(
              onTap: (!task.isDone && !state.isLocked) ? () => vm.toggleSubTask(s.id) : null,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  Icon(s.isDone ? Icons.check_circle_rounded : Icons.circle_outlined, size: 20, color: s.isDone ? AppColors.primary : AppColors.textMuted),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s.title, style: TextStyle(color: s.isDone ? AppColors.textDisabled : AppColors.textPrimary, decoration: s.isDone ? TextDecoration.lineThrough : null))),
                ]),
              ),
            )),
          ],
        ],
      ),
      bottomNavigationBar: (task.isDone || state.isLocked) ? null : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async { await vm.completeTask(); if (context.mounted) context.pop(); },
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('完了にする', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final TaskCategory category;
  @override
  Widget build(BuildContext context) {
    final (color, bg, border) = switch (category) {
      TaskCategory.rock => (AppColors.rock, AppColors.rockBg, AppColors.rockBorder),
      TaskCategory.pebble => (AppColors.pebble, AppColors.pebbleBg, AppColors.pebbleBorder),
      TaskCategory.sand => (AppColors.sand, AppColors.sandBg, AppColors.sandBorder),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99), border: Border.all(color: border)),
      child: Text(category.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textDisabled, letterSpacing: 0.8));
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, this.color});
  final String icon, label;
  final Color? color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(99), border: Border.all(color: AppColors.border)),
    child: Text('$icon $label', style: TextStyle(fontSize: 11, color: color ?? AppColors.textSecondary)),
  );
}
