import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/state/session_provider.dart';

class EntryPage extends ConsumerWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('AccountFlow', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Demo Banking Portal'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(sessionProvider.notifier).state =
                    const SessionState(authenticated: true, role: 'CUSTOMER');
                context.go('/dashboard');
              },
              child: const Text('Enter Portal'),
            )
          ],
        ),
      ),
    );
  }
}
