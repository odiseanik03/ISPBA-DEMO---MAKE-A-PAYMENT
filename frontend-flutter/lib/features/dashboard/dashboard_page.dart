import 'package:flutter/material.dart';
import '../accounts/data/accounts_api.dart';
import '../reports/data/reports_api.dart';
import '../transactions/data/transactions_api.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        AccountsApi().fetchAccounts(),
        ReportsApi().fetchSummary(),
        TransactionsApi().fetchTransactions(page: 0, size: 5),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load dashboard: ${snapshot.error}'));
        }
        final accounts = snapshot.data![0] as List;
        final report = snapshot.data![1];
        final txns = snapshot.data![2] as List;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 16, children: [
            _Kpi(title: 'Accounts', value: '${accounts.length}'),
            _Kpi(title: 'Total transactions', value: '${report.totalTransactions}'),
            _Kpi(title: 'Recent transactions', value: '${txns.length}'),
          ]),
        ]);
      },
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title;
  final String value;
  const _Kpi({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
