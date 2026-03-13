class AccountModel {
  final int id;
  final String maskedAccountNumber;
  final String accountType;
  final double availableBalance;
  final String currency;
  final String status;

  AccountModel({
    required this.id,
    required this.maskedAccountNumber,
    required this.accountType,
    required this.availableBalance,
    required this.currency,
    required this.status,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'] as int,
        maskedAccountNumber: json['maskedAccountNumber'] as String,
        accountType: json['accountType'] as String,
        availableBalance: (json['availableBalance'] as num).toDouble(),
        currency: json['currency'] as String,
        status: json['status'] as String,
      );
}
