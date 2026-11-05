class SiteVisitHistoryModel {
  final String id;
  final String clientName;
  final String projectNo;
  final String senderUserName;
  final String actionType;
  final String createdAt;

  SiteVisitHistoryModel({
    required this.id,
    required this.clientName,
    required this.projectNo,
    required this.createdAt,
    this.senderUserName = '',
    this.actionType = 'exported_pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectNo': projectNo,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory SiteVisitHistoryModel.fromJson(Map<String, dynamic> json) {
    return SiteVisitHistoryModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? json['project_no']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'exported_pdf',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}

