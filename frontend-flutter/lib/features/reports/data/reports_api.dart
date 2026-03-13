import '../../../core/networking/api_client.dart';
import '../../../shared/models/report_model.dart';

class ReportsApi {
  final ApiClient _client = ApiClient();

  Future<ReportSummaryModel> fetchSummary() async {
    final data = await _client.getJson('/api/reports/summary') as Map<String, dynamic>;
    return ReportSummaryModel.fromJson(data);
  }
}
