// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_create_edit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskCreateEditViewModelHash() =>
    r'3ce68856da35d9b7ef5b03d30479eb34dc099665';

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

abstract class _$TaskCreateEditViewModel
    extends BuildlessAutoDisposeNotifier<TaskCreateEditState> {
  late final String? taskId;

  TaskCreateEditState build({String? taskId});
}

/// See also [TaskCreateEditViewModel].
@ProviderFor(TaskCreateEditViewModel)
const taskCreateEditViewModelProvider = TaskCreateEditViewModelFamily();

/// See also [TaskCreateEditViewModel].
class TaskCreateEditViewModelFamily extends Family<TaskCreateEditState> {
  /// See also [TaskCreateEditViewModel].
  const TaskCreateEditViewModelFamily();

  /// See also [TaskCreateEditViewModel].
  TaskCreateEditViewModelProvider call({String? taskId}) {
    return TaskCreateEditViewModelProvider(taskId: taskId);
  }

  @override
  TaskCreateEditViewModelProvider getProviderOverride(
    covariant TaskCreateEditViewModelProvider provider,
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
  String? get name => r'taskCreateEditViewModelProvider';
}

/// See also [TaskCreateEditViewModel].
class TaskCreateEditViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          TaskCreateEditViewModel,
          TaskCreateEditState
        > {
  /// See also [TaskCreateEditViewModel].
  TaskCreateEditViewModelProvider({String? taskId})
    : this._internal(
        () => TaskCreateEditViewModel()..taskId = taskId,
        from: taskCreateEditViewModelProvider,
        name: r'taskCreateEditViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskCreateEditViewModelHash,
        dependencies: TaskCreateEditViewModelFamily._dependencies,
        allTransitiveDependencies:
            TaskCreateEditViewModelFamily._allTransitiveDependencies,
        taskId: taskId,
      );

  TaskCreateEditViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String? taskId;

  @override
  TaskCreateEditState runNotifierBuild(
    covariant TaskCreateEditViewModel notifier,
  ) {
    return notifier.build(taskId: taskId);
  }

  @override
  Override overrideWith(TaskCreateEditViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskCreateEditViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<
    TaskCreateEditViewModel,
    TaskCreateEditState
  >
  createElement() {
    return _TaskCreateEditViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskCreateEditViewModelProvider && other.taskId == taskId;
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
mixin TaskCreateEditViewModelRef
    on AutoDisposeNotifierProviderRef<TaskCreateEditState> {
  /// The parameter `taskId` of this provider.
  String? get taskId;
}

class _TaskCreateEditViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          TaskCreateEditViewModel,
          TaskCreateEditState
        >
    with TaskCreateEditViewModelRef {
  _TaskCreateEditViewModelProviderElement(super.provider);

  @override
  String? get taskId => (origin as TaskCreateEditViewModelProvider).taskId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
