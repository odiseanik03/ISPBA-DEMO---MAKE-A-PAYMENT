import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String status = 'ALL';
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['TXN-DEMO001', 'Acme Ltd', '€120.00', 'PENDING', 'Office supplies'],
      ['TXN-DEMO002', 'Global Services', '€78.50', 'COMPLETED', 'Consulting fee'],
      ['TXN-DEMO003', 'Vendor X', '€250.00', 'FAILED', 'Invoice 9221'],
    ].where((r) => status == 'ALL' || r[3] == status).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Transactions', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(children: [
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: 'ALL', child: Text('All statuses')),
              DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
              DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
              DropdownMenuItem(value: 'FAILED', child: Text('Failed')),
            ],
            onChanged: (v) => setState(() => status = v ?? 'ALL'),
          ),
        ),
      ]),
      const SizedBox(height: 12),
      Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: const [
            DataColumn(label: Text('Reference')),
            DataColumn(label: Text('Beneficiary')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Description')),
          ], rows: rows.map((r) => DataRow(cells: [
            DataCell(Text(r[0])), DataCell(Text(r[1])), DataCell(Text(r[2])), DataCell(_badge(r[3])), DataCell(Text(r[4]))
          ])).toList()),
        ),
      ),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(onPressed: page > 1 ? () => setState(() => page -= 1) : null, child: const Text('Prev')),
        Text('Page $page'),
        TextButton(onPressed: () => setState(() => page += 1), child: const Text('Next')),
      ])
    ]);
  }

  Widget _badge(String status) {
    Color bg;
    switch (status) {
      case 'COMPLETED':
        bg = Colors.green.shade100;
        break;
      case 'FAILED':
        bg = Colors.red.shade100;
        break;
      default:
        bg = Colors.orange.shade100;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: const TextStyle(fontSize: 12)),
    );
  }
}
