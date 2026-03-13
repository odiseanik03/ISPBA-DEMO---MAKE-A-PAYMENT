import 'package:flutter_test/flutter_test.dart';
import 'package:accountflow_frontend/core/state/session_provider.dart';

void main() {
  test('session state copyWith updates role', () {
    const state = SessionState(authenticated: true, role: 'CUSTOMER');
    final admin = state.copyWith(role: 'ADMIN');
    expect(admin.role, 'ADMIN');
    expect(admin.authenticated, true);
  });
}
