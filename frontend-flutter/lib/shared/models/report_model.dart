class ReportSummaryModel {
  final int totalTransactions;
  final int failedTransactions;
  final int suspiciousCount;

  ReportSummaryModel({required this.totalTransactions, required this.failedTransactions, required this.suspiciousCount});

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) => ReportSummaryModel(
        totalTransactions: json['totalTransactions'] as int,
        failedTransactions: json['failedTransactions'] as int,
        suspiciousCount: json['suspiciousCount'] as int,
      );
}
