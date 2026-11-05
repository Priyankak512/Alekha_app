class FeesReminderHistoryModel {
  final String id;
  final String name;
  final String projectNo;
  final String amountPending;
  final String projectCategory;
  final String invoiceNo;
  final String feesStage;
  final String note;
  final String regards;
  final String senderUserName;
  final String actionType; // 'shared' or 'copied'
  final String createdAt;

  FeesReminderHistoryModel({
    required this.id,
    required this.name,
    required this.projectNo,
    required this.amountPending,
    required this.createdAt,
    this.projectCategory = '',
    this.invoiceNo = '',
    this.feesStage = '',
    this.note = '',
    this.regards = '',
    this.senderUserName = '',
    this.actionType = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectNo': projectNo,
      'amountPending': amountPending,
      'projectCategory': projectCategory,
      'invoiceNo': invoiceNo,
      'feesStage': feesStage,
      'note': note,
      'regards': regards,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory FeesReminderHistoryModel.fromJson(Map<String, dynamic> json) {
    return FeesReminderHistoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? '',
      amountPending: json['amountPending']?.toString() ?? '',
      projectCategory: json['projectCategory']?.toString() ?? '',
      invoiceNo: json['invoiceNo']?.toString() ?? '',
      feesStage: json['feesStage']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      regards: json['regards']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
