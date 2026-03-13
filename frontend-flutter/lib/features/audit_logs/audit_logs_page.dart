import 'package:flutter/material.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(columns: const [
        DataColumn(label: Text('Action')),
        DataColumn(label: Text('Entity')),
        DataColumn(label: Text('Actor')),
      ], rows: const [
        DataRow(cells: [
          DataCell(Text('PAYMENT_CREATED')),
          DataCell(Text('PAYMENT#1')),
          DataCell(Text('demo.customer')),
        ])
      ]),
    );
  }
}
