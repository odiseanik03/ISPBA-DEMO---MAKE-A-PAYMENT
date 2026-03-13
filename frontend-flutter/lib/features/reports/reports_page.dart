import 'package:flutter/material.dart';
import 'data/reports_api.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReportsApi().fetchSummary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load report summary: ${snapshot.error}'));
        }
        final summary = snapshot.data!;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Reports', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 16, children: [
            _Metric(title: 'Total transactions', value: '${summary.totalTransactions}'),
            _Metric(title: 'Failed', value: '${summary.failedTransactions}'),
            _Metric(title: 'Suspicious', value: '${summary.suspiciousCount}'),
          ])
        ]);
      },
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  const _Metric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
