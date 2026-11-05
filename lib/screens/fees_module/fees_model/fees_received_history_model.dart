class FeesReceivedHistoryModel {
  final String id;
  final String clientName;
  final String projectNo;
  final String amountReceived;
  final String feesStage;
  final String invoiceNo;
  final String paymentMode;
  final String feesSummary;
  final String regards;
  final String senderUserName;
  final String actionType; // 'shared' or 'copied'
  final String createdAt;

  FeesReceivedHistoryModel({
    required this.id,
    required this.clientName,
    required this.projectNo,
    required this.amountReceived,
    required this.createdAt,
    this.feesStage = '',
    this.invoiceNo = '',
    this.paymentMode = '',
    this.feesSummary = '',
    this.regards = '',
    this.senderUserName = '',
    this.actionType = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectNo': projectNo,
      'amountReceived': amountReceived,
      'feesStage': feesStage,
      'invoiceNo': invoiceNo,
      'paymentMode': paymentMode,
      'feesSummary': feesSummary,
      'regards': regards,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory FeesReceivedHistoryModel.fromJson(Map<String, dynamic> json) {
    return FeesReceivedHistoryModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? '',
      amountReceived: json['amountReceived']?.toString() ?? '',
      feesStage: json['feesStage']?.toString() ?? '',
      invoiceNo: json['invoiceNo']?.toString() ?? '',
      paymentMode: json['paymentMode']?.toString() ?? '',
      feesSummary: json['feesSummary']?.toString() ?? '',
      regards: json['regards']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
