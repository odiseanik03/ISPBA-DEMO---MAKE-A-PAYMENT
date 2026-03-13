import 'package:flutter/material.dart';
import 'data/transactions_api.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String status = 'ALL';
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Transactions', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
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
          onChanged: (v) => setState(() {
            status = v ?? 'ALL';
            page = 0;
          }),
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: FutureBuilder(
          future: TransactionsApi().fetchTransactions(status: status, page: page, size: 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Failed to load transactions: ${snapshot.error}'));
            }
            final rows = snapshot.data ?? [];
            return Column(children: [
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Reference')),
                        DataColumn(label: Text('Beneficiary')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: rows
                          .map(
                            (r) => DataRow(cells: [
                              DataCell(Text(r.reference)),
                              DataCell(Text(r.beneficiaryName)),
                              DataCell(Text('${r.currency} ${r.amount.toStringAsFixed(2)}')),
                              DataCell(Text(r.status)),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(onPressed: page > 0 ? () => setState(() => page -= 1) : null, child: const Text('Prev')),
                Text('Page ${page + 1}'),
                TextButton(onPressed: () => setState(() => page += 1), child: const Text('Next')),
              ])
            ]);
          },
        ),
      ),
    ]);
  }
}
