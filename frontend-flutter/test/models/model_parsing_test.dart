import 'package:flutter_test/flutter_test.dart';
import 'package:accountflow_frontend/shared/models/account_model.dart';

void main() {
  test('account model parses json', () {
    final model = AccountModel.fromJson({
      'id': 1,
      'maskedAccountNumber': '**** **** **** 3000',
      'accountType': 'CURRENT',
      'availableBalance': 1200.0,
      'currency': 'EUR',
      'status': 'ACTIVE',
    });

    expect(model.id, 1);
    expect(model.currency, 'EUR');
  });
}
