class SelectionHistoryModel {
  final String id;
  final String clientName;
  final String projectNo;
  final String selectionDate;
  final String selectionTime;
  final String senderUserName;
  final String actionType;
  final String createdAt;

  SelectionHistoryModel({
    required this.id,
    required this.clientName,
    required this.projectNo,
    required this.createdAt,
    this.selectionDate = '',
    this.selectionTime = '',
    this.senderUserName = '',
    this.actionType = 'exported_pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectNo': projectNo,
      'selectionDate': selectionDate,
      'selectionTime': selectionTime,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory SelectionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SelectionHistoryModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? json['project_no']?.toString() ?? '',
      selectionDate: json['selectionDate']?.toString() ?? json['selection_date']?.toString() ?? '',
      selectionTime: json['selectionTime']?.toString() ?? json['selection_time']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'exported_pdf',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}
