import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/task_category.dart';
import 'task_create_edit_view_model.dart';

class TaskCreateEditView extends ConsumerStatefulWidget {
  const TaskCreateEditView({super.key, this.taskId});
  final String? taskId;

  @override
  ConsumerState<TaskCreateEditView> createState() => _TaskCreateEditViewState();
}

class _TaskCreateEditViewState extends ConsumerState<TaskCreateEditView> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _memoCtrl;
  late final TextEditingController _subTaskCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _memoCtrl = TextEditingController();
    _subTaskCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(taskCreateEditViewModelProvider(taskId: widget.taskId));
      _titleCtrl.text = state.title;
      _memoCtrl.text = state.memo;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _memoCtrl.dispose();
    _subTaskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskCreateEditViewModelProvider(taskId: widget.taskId));
    final vm = ref.read(taskCreateEditViewModelProvider(taskId: widget.taskId).notifier);
    final isEdit = state.isEditMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(isEdit ? 'タスクを編集' : 'タスクを追加'),
        actions: [
          TextButton(
            onPressed: state.canSave
                ? () async {
                    final ok = await vm.save();
                    if (ok && context.mounted) context.pop();
                  }
                : null,
            child: Text(
              isEdit ? '更新' : '追加',
              style: TextStyle(
                color: state.canSave ? AppColors.primaryLight : AppColors.textDisabled,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Category selector ──
          _SectionLabel(label: 'カテゴリ'),
          const SizedBox(height: 10),
          Row(
            children: TaskCategory.values.map((c) {
              final isSelected = state.category == c;
              final (color, bgColor) = _categoryStyle(c);
              return Expanded(
                child: GestureDetector(
                  onTap: () => vm.setCategory(c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? bgColor : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(_categoryEmoji(c), style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? color : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (state.category == TaskCategory.rock) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.rockBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.rockBorder),
              ),
              child: Row(
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isEdit
                          ? 'Rock #${(state.rockOrder ?? 0) + 1} として登録されています'
                          : 'Rock #${state.nextRockPosition + 1} として末尾に追加されます',
                      style: const TextStyle(fontSize: 12, color: AppColors.rock),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // ── Title ──
          _SectionLabel(label: 'タイトル *'),
          const SizedBox(height: 10),
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            onChanged: vm.setTitle,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'やることを入力…',
              counterText: '',
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 24),

          // ── Due date ──
          _SectionLabel(label: '期日'),
          const SizedBox(height: 10),
          Row(
            children: [
              Switch(
                value: state.hasDueDate,
                onChanged: vm.toggleDueDate,
                activeThumbColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              if (state.hasDueDate && state.dueDate != null)
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.dueDate!,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) vm.setDueDate(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '📅 ${state.dueDate!.year}/${state.dueDate!.month}/${state.dueDate!.day}',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    ),
                  ),
                )
              else
                const Text('期日なし', style: TextStyle(color: AppColors.textDisabled)),
            ],
          ),
          const SizedBox(height: 24),

          // ── Memo ──
          _SectionLabel(label: 'メモ'),
          const SizedBox(height: 10),
          TextField(
            controller: _memoCtrl,
            onChanged: vm.setMemo,
            maxLines: 4,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: '追記事項があれば…',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),

          // ── Subtasks ──
          _SectionLabel(label: 'サブタスク'),
          const SizedBox(height: 10),
          ...state.subTasks.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => vm.toggleSubTask(s.id),
                  child: Icon(
                    s.isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: s.isDone ? AppColors.primary : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.title,
                    style: TextStyle(
                      color: s.isDone ? AppColors.textDisabled : AppColors.textPrimary,
                      decoration: s.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: AppColors.textDisabled),
                  onPressed: () => vm.removeSubTask(s.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _subTaskCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'サブタスクを追加…',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onSubmitted: (v) {
                    vm.addSubTask(v);
                    _subTaskCtrl.clear();
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  vm.addSubTask(_subTaskCtrl.text);
                  _subTaskCtrl.clear();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  (Color, Color) _categoryStyle(TaskCategory c) => switch (c) {
        TaskCategory.rock => (AppColors.rock, AppColors.rockBg),
        TaskCategory.pebble => (AppColors.pebble, AppColors.pebbleBg),
        TaskCategory.sand => (AppColors.sand, AppColors.sandBg),
      };

  String _categoryEmoji(TaskCategory c) => switch (c) {
        TaskCategory.rock => '🔒',
        TaskCategory.pebble => '🪨',
        TaskCategory.sand => '🏖️',
      };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textDisabled,
          letterSpacing: 0.8,
        ),
      );
}
