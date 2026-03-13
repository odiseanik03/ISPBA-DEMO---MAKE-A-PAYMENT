import 'package:flutter_test/flutter_test.dart';
import 'package:accountflow_frontend/shared/models/audit_log_model.dart';

void main() {
  test('audit model parses minimal json', () {
    final model = AuditLogModel.fromJson({
      'id': 1,
      'actorUserId': 1,
      'actionType': 'PAYMENT_CREATED',
      'entityType': 'PAYMENT',
      'entityId': '9',
      'createdAt': '2026-01-01T00:00:00Z'
    });
    expect(model.id, 1);
    expect(model.actionType, 'PAYMENT_CREATED');
  });
}
