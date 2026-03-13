import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 16, children: const [
        _Kpi(title: 'Available balance', value: '€5,000.00'),
        _Kpi(title: 'Pending payments', value: '1'),
        _Kpi(title: 'Suspicious flags', value: '0'),
      ])
    ]);
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }
}
