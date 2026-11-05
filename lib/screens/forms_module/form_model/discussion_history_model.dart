class DiscussionHistoryModel {
  final String id;
  final String clientName;
  final String projectNo;
  final String discussionDate;
  final String discussionTime;
  final String discussionFrom;
  final String senderUserName;
  final String actionType;
  final String createdAt;

  DiscussionHistoryModel({
    required this.id,
    required this.clientName,
    required this.projectNo,
    required this.discussionDate,
    required this.discussionTime,
    required this.discussionFrom,
    required this.createdAt,
    this.senderUserName = '',
    this.actionType = 'shared',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectNo': projectNo,
      'discussionDate': discussionDate,
      'discussionTime': discussionTime,
      'discussionFrom': discussionFrom,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory DiscussionHistoryModel.fromJson(Map<String, dynamic> json) {
    return DiscussionHistoryModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? json['project_no']?.toString() ?? '',
      discussionDate: json['discussionDate']?.toString() ?? json['discussion_date']?.toString() ?? '',
      discussionTime: json['discussionTime']?.toString() ?? json['discussion_time']?.toString() ?? '',
      discussionFrom: json['discussionFrom']?.toString() ?? json['discussion_from']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'shared',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}

