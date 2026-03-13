class TransactionModel {
  final int id;
  final String reference;
  final String status;
  final double amount;
  final String currency;
  final String destinationAccountNumber;
  final String beneficiaryName;
  final bool riskFlag;

  TransactionModel({
    required this.id,
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    required this.destinationAccountNumber,
    required this.beneficiaryName,
    required this.riskFlag,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as int,
        reference: json['reference'] as String,
        status: json['status'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        destinationAccountNumber: json['destinationAccountNumber'] as String,
        beneficiaryName: json['beneficiaryName'] as String,
        riskFlag: json['riskFlag'] as bool? ?? false,
      );
}
