import '../../../core/networking/api_client.dart';
import '../../../shared/models/transaction_model.dart';

class TransactionsApi {
  final ApiClient _client = ApiClient();

  Future<List<TransactionModel>> fetchTransactions({String? status, int page = 0, int size = 10}) async {
    final qp = <String, String>{'page': '$page', 'size': '$size'};
    if (status != null && status != 'ALL') qp['status'] = status;
    final uri = Uri(path: '/api/transactions', queryParameters: qp).toString();
    final data = await _client.getJson(uri) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
