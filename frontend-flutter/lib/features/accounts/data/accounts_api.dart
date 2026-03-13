import '../../../core/networking/api_client.dart';
import '../../../shared/models/account_model.dart';

class AccountsApi {
  final ApiClient _client = ApiClient();

  Future<List<AccountModel>> fetchAccounts() async {
    final data = await _client.getJson('/api/accounts') as List<dynamic>;
    return data.map((e) => AccountModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
