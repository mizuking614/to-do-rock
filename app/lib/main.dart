import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/task/data/task_repository.dart';

import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 通知の初期化
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  // Hive初期化
  await Hive.initFlutter();

  // TaskRepositoryのHiveBoxを開く
  final taskRepo = TaskRepository();
  await taskRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        // 初期化済みのリポジトリをオーバーライドで注入
        taskRepositoryProvider.overrideWithValue(taskRepo),
        // 通知サービスを注入
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const ToDoRockApp(),
    ),
  );
}

class ToDoRockApp extends StatelessWidget {
  const ToDoRockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'to do rock',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
