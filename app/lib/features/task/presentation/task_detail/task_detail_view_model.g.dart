// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskDetailViewModelHash() =>
    r'a70c3619bca890ecc8d8e62a04c50f9b22070a46';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TaskDetailViewModel
    extends BuildlessAutoDisposeNotifier<TaskDetailState> {
  late final String taskId;

  TaskDetailState build({required String taskId});
}

/// See also [TaskDetailViewModel].
@ProviderFor(TaskDetailViewModel)
const taskDetailViewModelProvider = TaskDetailViewModelFamily();

/// See also [TaskDetailViewModel].
class TaskDetailViewModelFamily extends Family<TaskDetailState> {
  /// See also [TaskDetailViewModel].
  const TaskDetailViewModelFamily();

  /// See also [TaskDetailViewModel].
  TaskDetailViewModelProvider call({required String taskId}) {
    return TaskDetailViewModelProvider(taskId: taskId);
  }

  @override
  TaskDetailViewModelProvider getProviderOverride(
    covariant TaskDetailViewModelProvider provider,
  ) {
    return call(taskId: provider.taskId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskDetailViewModelProvider';
}

/// See also [TaskDetailViewModel].
class TaskDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<TaskDetailViewModel, TaskDetailState> {
  /// See also [TaskDetailViewModel].
  TaskDetailViewModelProvider({required String taskId})
    : this._internal(
        () => TaskDetailViewModel()..taskId = taskId,
        from: taskDetailViewModelProvider,
        name: r'taskDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskDetailViewModelHash,
        dependencies: TaskDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            TaskDetailViewModelFamily._allTransitiveDependencies,
        taskId: taskId,
      );

  TaskDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  TaskDetailState runNotifierBuild(covariant TaskDetailViewModel notifier) {
    return notifier.build(taskId: taskId);
  }

  @override
  Override overrideWith(TaskDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskDetailViewModelProvider._internal(
        () => create()..taskId = taskId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TaskDetailViewModel, TaskDetailState>
  createElement() {
    return _TaskDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailViewModelProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskDetailViewModelRef
    on AutoDisposeNotifierProviderRef<TaskDetailState> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<TaskDetailViewModel, TaskDetailState>
    with TaskDetailViewModelRef {
  _TaskDetailViewModelProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskDetailViewModelProvider).taskId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
