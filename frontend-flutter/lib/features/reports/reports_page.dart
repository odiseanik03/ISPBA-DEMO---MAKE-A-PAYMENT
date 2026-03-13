import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Reports', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 16, children: const [
        _Metric(title: 'Total transactions', value: '24'),
        _Metric(title: 'Failed', value: '1'),
        _Metric(title: 'Suspicious', value: '0'),
        _Metric(title: 'Data quality issues', value: '0'),
      ])
    ]);
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
