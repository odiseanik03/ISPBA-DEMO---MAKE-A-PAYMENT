import 'package:accountflow_frontend/core/state/session_provider.dart';
import 'package:accountflow_frontend/shared/layout/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin role sees audit logs navigation item', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith((ref) => StateController(const SessionState(authenticated: true, role: 'ADMIN'))),
        ],
        child: const MaterialApp(
          home: AppShell(
            child: Text('content'),
          ),
        ),
      ),
    );

    expect(find.text('Audit logs'), findsOneWidget);
  });

  testWidgets('customer role does not see audit logs navigation item', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith((ref) => StateController(const SessionState(authenticated: true, role: 'CUSTOMER'))),
        ],
        child: const MaterialApp(
          home: AppShell(
            child: Text('content'),
          ),
        ),
      ),
    );

    expect(find.text('Audit logs'), findsNothing);
  });
}
