class OfferLetterHistoryModel {
  final String id;
  final String offerType; // 'Architecture', 'Interior', 'Basic'
  final String clientName;
  final String contactNo;
  final String location;
  final String senderUserName;
  final String actionType;
  final String createdAt;

  OfferLetterHistoryModel({
    required this.id,
    required this.offerType,
    required this.clientName,
    required this.contactNo,
    required this.location,
    required this.createdAt,
    this.senderUserName = '',
    this.actionType = 'exported_pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offerType': offerType,
      'clientName': clientName,
      'contactNo': contactNo,
      'location': location,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'createdAt': createdAt,
    };
  }

  factory OfferLetterHistoryModel.fromJson(Map<String, dynamic> json) {
    return OfferLetterHistoryModel(
      id: json['id']?.toString() ?? '',
      offerType: json['offerType']?.toString() ?? json['offer_type']?.toString() ?? 'Architecture',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      contactNo: json['contactNo']?.toString() ?? json['contact_no']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'exported_pdf',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}

