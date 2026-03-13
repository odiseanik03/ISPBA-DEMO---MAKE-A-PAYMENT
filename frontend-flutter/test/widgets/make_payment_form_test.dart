import 'package:accountflow_frontend/features/payments/make_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('continue button enables only when required fields are valid', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MakePaymentPage())));

    ElevatedButton button = tester.widget(find.widgetWithText(ElevatedButton, 'Continue'));
    expect(button.onPressed, isNull);

    await tester.enterText(find.widgetWithText(TextFormField, 'Destination account number'), 'RO49AAAA1B31007593840000');
    await tester.enterText(find.widgetWithText(TextFormField, 'Beneficiary name'), 'Alice Receiver');
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '125.30');
    await tester.pump();

    button = tester.widget(find.widgetWithText(ElevatedButton, 'Continue'));
    expect(button.onPressed, isNotNull);
  });
}
