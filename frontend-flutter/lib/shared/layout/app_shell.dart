import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/state/session_provider.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = '/dashboard';
    try {
      path = GoRouterState.of(context).uri.path;
    } catch (_) {}
    final session = ref.watch(sessionProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 900;
        final nav = _nav(context, path, session.role == 'ADMIN');

        if (mobile) {
          return Scaffold(
            drawer: Drawer(child: nav),
            appBar: AppBar(title: const Text('AccountFlow')),
            body: Padding(padding: const EdgeInsets.all(12), child: child),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              Container(width: 250, color: Colors.white, child: nav),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 72,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      color: const Color(0xFFF8F8F8),
                      alignment: Alignment.centerLeft,
                      child: const Text('How can we help you today?', style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Padding(padding: const EdgeInsets.all(24), child: child))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _nav(BuildContext context, String path, bool isAdmin) {
    return ListView(
      semanticChildCount: isAdmin ? 6 : 5,
      padding: const EdgeInsets.all(16),
      children: [
        const Text('AccountFlow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        const SizedBox(height: 24),
        _item(context, '/dashboard', 'Dashboard', path),
        _item(context, '/accounts', 'Accounts', path),
        _item(context, '/payments/new', 'Make payment', path),
        _item(context, '/transactions', 'Transactions', path),
        _item(context, '/reports', 'Reports', path),
        if (isAdmin) _item(context, '/admin/audit-logs', 'Audit logs', path),
      ],
    );
  }

  Widget _item(BuildContext context, String route, String title, String current) {
    final active = current == route;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: active ? const Color(0xFFFFF1E6) : null,
      leading: CircleAvatar(
        backgroundColor: active ? const Color(0xFFFF7A00) : const Color(0xFFE5E7EB),
        radius: 12,
      ),
      title: Semantics(label: 'Navigation item $title', child: Text(title)),
      onTap: () => context.go(route),
    );
  }
}
