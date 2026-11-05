class InvoiceHistoryModel {
  final String id;
  final String clientName;
  final String projectNo;
  final String invoiceNo;
  final String contactNo;
  final String totalAmount;
  final String paymentStatus; // 'Fees Paid' or 'Fees Unpaid'
  final String senderUserName;
  final String actionType; // 'exported_pdf'
  final String invoiceType; // 'Alekha Invoice', 'GST Invoice', etc.
  final String createdAt;

  InvoiceHistoryModel({
    required this.id,
    required this.clientName,
    required this.invoiceNo,
    required this.totalAmount,
    required this.createdAt,
    this.projectNo = '',
    this.contactNo = '',
    this.paymentStatus = '',
    this.senderUserName = '',
    this.actionType = 'exported_pdf',
    this.invoiceType = 'Invoice',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectNo': projectNo,
      'invoiceNo': invoiceNo,
      'contactNo': contactNo,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'senderUserName': senderUserName,
      'actionType': actionType,
      'invoiceType': invoiceType,
      'createdAt': createdAt,
    };
  }

  factory InvoiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return InvoiceHistoryModel(
      id: json['id']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? json['client_name']?.toString() ?? '',
      projectNo: json['projectNo']?.toString() ?? json['project_no']?.toString() ?? '',
      invoiceNo: json['invoiceNo']?.toString() ?? json['invoice_no']?.toString() ?? '',
      contactNo: json['contactNo']?.toString() ?? json['contact_no']?.toString() ?? '',
      totalAmount: json['totalAmount']?.toString() ?? json['total_amount']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? json['payment_status']?.toString() ?? '',
      senderUserName: json['senderUserName']?.toString() ?? json['sender_user_name']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? json['action_type']?.toString() ?? 'exported_pdf',
      invoiceType: json['invoiceType']?.toString() ?? json['invoice_type']?.toString() ?? 'Invoice',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }
}
