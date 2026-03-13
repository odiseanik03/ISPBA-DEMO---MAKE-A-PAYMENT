import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/entry/entry_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const EntryPage()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
  ],
);
