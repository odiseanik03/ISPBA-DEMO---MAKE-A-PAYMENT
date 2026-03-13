import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/session_provider.dart';
import 'data/audit_logs_api.dart';

class AuditLogsPage extends ConsumerStatefulWidget {
  const AuditLogsPage({super.key});

  @override
  ConsumerState<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends ConsumerState<AuditLogsPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    if (session.role != 'ADMIN') {
      return const Center(child: Text('Admin access required for audit logs.'));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Audit logs', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Expanded(
        child: FutureBuilder(
          future: AuditLogsApi().fetchAuditLogs(page: page, size: 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Failed to load audit logs: ${snapshot.error}'));
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('No audit logs found.'));
            }
            return Column(children: [
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(columns: const [
                      DataColumn(label: Text('Action')),
                      DataColumn(label: Text('Entity')),
                      DataColumn(label: Text('Actor')),
                      DataColumn(label: Text('When')),
                    ], rows: items.map((i) => DataRow(cells: [
                      DataCell(Text(i.actionType)),
                      DataCell(Text('${i.entityType}${i.entityId == null ? '' : '#${i.entityId}'}')),
                      DataCell(Text('${i.actorUserId ?? '-'}')),
                      DataCell(Text(i.createdAt ?? '-')),
                    ])).toList()),
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
      )
    ]);
  }
}
