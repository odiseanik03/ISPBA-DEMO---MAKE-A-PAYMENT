import '../../../core/networking/api_client.dart';
import '../../../shared/models/audit_log_model.dart';

class AuditLogsApi {
  final ApiClient _client = ApiClient();

  Future<List<AuditLogModel>> fetchAuditLogs({int page = 0, int size = 20}) async {
    final uri = Uri(path: '/api/admin/audit-logs', queryParameters: {'page': '$page', 'size': '$size'}).toString();
    final data = await _client.getJson(uri, headers: {'X-Demo-Role': 'ADMIN'}) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((e) => AuditLogModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
