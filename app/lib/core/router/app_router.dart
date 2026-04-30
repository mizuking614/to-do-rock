
import 'package:go_router/go_router.dart';
import '../../features/task/presentation/home/home_view.dart';
import '../../features/task/presentation/task_create_edit/task_create_edit_view.dart';
import '../../features/task/presentation/task_detail/task_detail_view.dart';
import '../../features/stats/presentation/stats_view.dart';
import '../../features/calendar/presentation/calendar_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: 'task/create',
          name: 'taskCreate',
          builder: (context, state) => const TaskCreateEditView(),
        ),
        GoRoute(
          path: 'task/:id',
          name: 'taskDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskDetailView(taskId: id);
          },
          routes: [
            GoRoute(
              path: 'edit',
              name: 'taskEdit',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return TaskCreateEditView(taskId: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/stats',
      name: 'stats',
      builder: (context, state) => const StatsView(),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => const CalendarView(),
    ),
  ],
);
