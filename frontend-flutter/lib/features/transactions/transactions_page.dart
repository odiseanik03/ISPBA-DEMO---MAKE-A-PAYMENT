import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(columns: const [
        DataColumn(label: Text('Reference')),
        DataColumn(label: Text('Beneficiary')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Status')),
      ], rows: const [
        DataRow(cells: [DataCell(Text('TXN-DEMO001')), DataCell(Text('Acme Ltd')), DataCell(Text('€120.00')), DataCell(Text('PENDING'))]),
      ]),
    );
  }
}
