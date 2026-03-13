import '../../../core/networking/api_client.dart';

class PaymentsApi {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> payload) async {
    final data = await _client.postJson('/api/payments', payload) as Map<String, dynamic>;
    return data;
  }
}
