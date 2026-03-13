import 'package:accountflow_frontend/core/state/session_provider.dart';
import 'package:accountflow_frontend/features/audit_logs/audit_logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('non-admin user sees role guard message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith((ref) => StateController(const SessionState(authenticated: true, role: 'CUSTOMER'))),
        ],
        child: const MaterialApp(home: Scaffold(body: AuditLogsPage())),
      ),
    );

    expect(find.text('Admin access required for audit logs.'), findsOneWidget);
  });
}
