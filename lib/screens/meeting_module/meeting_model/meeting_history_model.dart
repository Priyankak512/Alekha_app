class MeetingHistoryModel {
  final String id;
  final String clientOrAgency;
  final String agencyName;
  final String clientName;
  final String projectNo;
  final String meetingDate;
  final String meetingTime;
  final String senderUserName;
  final String actionType;
  final String createdAt;

  MeetingHistoryModel({
    required this.id,
    required this.clientOrAgency,
    required this.agencyName,
    required this.clientName,
    required this.projectNo,
    required this.meetingDate,
    required this.meetingTime,
    required this.createdAt,
    this.senderUserName = '',
    this.actionType = 'shared',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientOrAgency': clientOrAgency,
      'agencyName': agencyName,
      'clientName': clientName,
      'projectNo': projectNo,
      'meetingDate': meetingDate,
      'meetingTime': meetingTime,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory MeetingHistoryModel.fromJson(Map<String, dynamic> json) {
    return MeetingHistoryModel(
      id: json['id']?.toString() ?? '',
      clientOrAgency: json['clientOrAgency']?.toString() ?? json['client_or_agency']?.toString() ?? '',
      agencyName: json['agencyName']?.toString() ?? json['agency_name']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? json['project_no']?.toString() ?? '',
      meetingDate: json['meetingDate']?.toString() ?? json['meeting_date']?.toString() ?? '',
      meetingTime: json['meetingTime']?.toString() ?? json['meeting_time']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'shared',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}

