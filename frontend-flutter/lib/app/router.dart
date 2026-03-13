import 'package:go_router/go_router.dart';
import '../features/accounts/accounts_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/entry/entry_page.dart';
import '../features/payments/make_payment_page.dart';
import '../features/transactions/transactions_page.dart';
import '../features/reports/reports_page.dart';
import '../features/audit_logs/audit_logs_page.dart';
import '../shared/layout/app_shell.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const EntryPage()),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
        GoRoute(path: '/accounts', builder: (context, state) => const AccountsPage()),
        GoRoute(path: '/payments/new', builder: (context, state) => const MakePaymentPage()),
        GoRoute(path: '/transactions', builder: (context, state) => const TransactionsPage()),
        GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
        GoRoute(path: '/admin/audit-logs', builder: (context, state) => const AuditLogsPage()),
      ],
    ),
  ],
);
