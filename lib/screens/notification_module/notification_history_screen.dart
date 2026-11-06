import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/fees_module/fees_model/fees_received_history_model.dart';
import 'package:alekha/screens/fees_module/fees_model/fees_reminder_history_model.dart';
import 'package:alekha/screens/fees_module/fees_provider/fees_received_provider.dart';
import 'package:alekha/screens/fees_module/fees_provider/fees_reminder_provider.dart';
import 'package:alekha/screens/invoice_generator/invoice_model/invoice_history_model.dart';
import 'package:alekha/screens/invoice_generator/invoice_provider/invoice_history_provider.dart';
import 'package:alekha/screens/create_pdf/site_visit_model/site_visit_history_model.dart';
import 'package:alekha/screens/create_pdf/site_visit_provider/site_visit_history_provider.dart';
import 'package:alekha/screens/meeting_module/meeting_model/meeting_history_model.dart';
import 'package:alekha/screens/meeting_module/meeting_provider/meeting_history_provider.dart';
import 'package:alekha/screens/selection_module/selection_model/selection_history_model.dart';
import 'package:alekha/screens/selection_module/selection_provider/selection_history_provider.dart';
import 'package:alekha/screens/offer_latter_module/offer_latter_model/offer_letter_history_model.dart';
import 'package:alekha/screens/offer_latter_module/offer_latter_provider/offer_letter_history_provider.dart';
import 'package:alekha/screens/forms_module/form_model/discussion_history_model.dart';
import 'package:alekha/screens/forms_module/form_provider/discussion_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum NotificationType { reminder, received, invoice, siteVisit, meeting, selection, offerLetter, discussion }

class NotificationItem {
  final String id;
  final String clientName;
  final String projectNo;
  final String amount;
  final String createdAt;
  final NotificationType type;
  final String? invoiceNo;
  final String? contactNo;
  final String? paymentStatus;
  final String? paymentMode;
  final String? senderUserName;
  final String? actionType;
  final String? invoiceType;
  final String? clientOrAgency;
  final String? agencyName;
  final String? meetingDate;
  final String? meetingTime;
  final String? selectionDate;
  final String? selectionTime;
  final String? location;
  final String? offerType;
  final String? discussionDate;
  final String? discussionTime;
  final String? discussionFrom;
  final dynamic originalModel;

  NotificationItem({
    required this.id,
    required this.clientName,
    required this.projectNo,
    required this.amount,
    required this.createdAt,
    required this.type,
    this.invoiceNo,
    this.contactNo,
    this.paymentStatus,
    this.paymentMode,
    this.senderUserName,
    this.actionType,
    this.invoiceType,
    this.clientOrAgency,
    this.agencyName,
    this.meetingDate,
    this.meetingTime,
    this.selectionDate,
    this.selectionTime,
    this.location,
    this.offerType,
    this.discussionDate,
    this.discussionTime,
    this.discussionFrom,
    this.originalModel,
  });
}

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = "";
  final int _pageSize = 10;
  int _displayedCount = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRefresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _displayedCount += _pageSize;
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  Future<void> _handleRefresh() async {
    final reminderProvider = Provider.of<FeesReminderProvider>(context, listen: false);
    final receivedProvider = Provider.of<FeesReceivedProvider>(context, listen: false);
    final invoiceProvider = Provider.of<InvoiceHistoryProvider>(context, listen: false);
    final siteVisitProvider = Provider.of<SiteVisitHistoryProvider>(context, listen: false);
    final meetingProvider = Provider.of<MeetingHistoryProvider>(context, listen: false);
    final selectionProvider = Provider.of<SelectionHistoryProvider>(context, listen: false);
    final offerProvider = Provider.of<OfferLetterHistoryProvider>(context, listen: false);
    final discussionProvider = Provider.of<DiscussionHistoryProvider>(context, listen: false);

    debugPrint("🔄 [NotificationScreen] Refreshing all notification data from Supabase for all users...");

    await Future.wait([
      reminderProvider.loadHistory(fromSupabase: true),
      receivedProvider.loadHistory(fromSupabase: true),
      invoiceProvider.loadHistory(fromSupabase: true),
      siteVisitProvider.loadHistory(fromSupabase: true),
      meetingProvider.loadHistory(fromSupabase: true),
      selectionProvider.loadHistory(fromSupabase: true),
      offerProvider.loadHistory(fromSupabase: true),
      discussionProvider.loadHistory(fromSupabase: true),
    ]);

    debugPrint("✅ [NotificationScreen] Refresh complete.");

    if (mounted) {
      setState(() {
        _displayedCount = _pageSize;
      });
    }
  }

  String _formatDateTime(String isoString) {
    if (isoString.isEmpty) return "Recently";
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return isoString;
    }
  }

  void _confirmDelete(BuildContext context, NotificationItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Notification"),
        content: Text("Are you sure you want to delete this notification for ${item.clientName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (item.type == NotificationType.reminder) {
                final reminderProvider = Provider.of<FeesReminderProvider>(context, listen: false);
                if (item.originalModel is FeesReminderHistoryModel) {
                  await reminderProvider.deleteReminderItem(item.originalModel as FeesReminderHistoryModel);
                }
              } else if (item.type == NotificationType.received) {
                final receivedProvider = Provider.of<FeesReceivedProvider>(context, listen: false);
                if (item.originalModel is FeesReceivedHistoryModel) {
                  await receivedProvider.deleteReceivedItem(item.originalModel as FeesReceivedHistoryModel);
                }
              } else if (item.type == NotificationType.invoice) {
                final invoiceProvider = Provider.of<InvoiceHistoryProvider>(context, listen: false);
                if (item.originalModel is InvoiceHistoryModel) {
                  await invoiceProvider.deleteInvoiceItem(item.originalModel as InvoiceHistoryModel);
                }
              } else if (item.type == NotificationType.siteVisit) {
                final siteVisitProvider = Provider.of<SiteVisitHistoryProvider>(context, listen: false);
                if (item.originalModel is SiteVisitHistoryModel) {
                  await siteVisitProvider.deleteSiteVisitItem(item.originalModel as SiteVisitHistoryModel);
                }
              } else if (item.type == NotificationType.meeting) {
                final meetingProvider = Provider.of<MeetingHistoryProvider>(context, listen: false);
                if (item.originalModel is MeetingHistoryModel) {
                  await meetingProvider.deleteMeetingItem(item.originalModel as MeetingHistoryModel);
                }
              } else if (item.type == NotificationType.selection) {
                final selectionProvider = Provider.of<SelectionHistoryProvider>(context, listen: false);
                if (item.originalModel is SelectionHistoryModel) {
                  await selectionProvider.deleteSelectionItem(item.originalModel as SelectionHistoryModel);
                }
              } else if (item.type == NotificationType.offerLetter) {
                final offerProvider = Provider.of<OfferLetterHistoryProvider>(context, listen: false);
                if (item.originalModel is OfferLetterHistoryModel) {
                  await offerProvider.deleteOfferLetterItem(item.originalModel as OfferLetterHistoryModel);
                }
              } else if (item.type == NotificationType.discussion) {
                final discProvider = Provider.of<DiscussionHistoryProvider>(context, listen: false);
                if (item.originalModel is DiscussionHistoryModel) {
                  await discProvider.deleteDiscussionItem(item.originalModel as DiscussionHistoryModel);
                }
              }

              showToast(message: "Notification deleted successfully", isPositive: false, context: context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<FeesReminderProvider>(context);
    final receivedProvider = Provider.of<FeesReceivedProvider>(context);
    final invoiceProvider = Provider.of<InvoiceHistoryProvider>(context);
    final siteVisitProvider = Provider.of<SiteVisitHistoryProvider>(context);
    final meetingProvider = Provider.of<MeetingHistoryProvider>(context);
    final selectionProvider = Provider.of<SelectionHistoryProvider>(context);
    final offerProvider = Provider.of<OfferLetterHistoryProvider>(context);
    final discussionProvider = Provider.of<DiscussionHistoryProvider>(context);

    // Combine histories into unified timeline list
    final List<NotificationItem> allItems = [];

    for (final FeesReminderHistoryModel r in reminderProvider.historyList) {
      allItems.add(NotificationItem(
        id: r.id,
        clientName: r.name,
        projectNo: r.projectNo,
        amount: r.amountPending,
        createdAt: r.createdAt,
        type: NotificationType.reminder,
        invoiceNo: r.invoiceNo,
        senderUserName: r.senderUserName,
        actionType: r.actionType,
        originalModel: r,
      ));
    }

    for (final FeesReceivedHistoryModel rc in receivedProvider.historyList) {
      allItems.add(NotificationItem(
        id: rc.id,
        clientName: rc.clientName,
        projectNo: rc.projectNo,
        amount: rc.amountReceived,
        createdAt: rc.createdAt,
        type: NotificationType.received,
        invoiceNo: rc.invoiceNo,
        paymentMode: rc.paymentMode,
        senderUserName: rc.senderUserName,
        actionType: rc.actionType,
        originalModel: rc,
      ));
    }

    for (final InvoiceHistoryModel inv in invoiceProvider.historyList) {
      allItems.add(NotificationItem(
        id: inv.id,
        clientName: inv.clientName,
        projectNo: inv.projectNo,
        amount: inv.totalAmount,
        createdAt: inv.createdAt,
        type: NotificationType.invoice,
        invoiceNo: inv.invoiceNo,
        contactNo: inv.contactNo,
        paymentStatus: inv.paymentStatus,
        senderUserName: inv.senderUserName,
        actionType: inv.actionType,
        invoiceType: inv.invoiceType,
        originalModel: inv,
      ));
    }

    for (final SiteVisitHistoryModel sv in siteVisitProvider.historyList) {
      allItems.add(NotificationItem(
        id: sv.id,
        clientName: sv.clientName,
        projectNo: sv.projectNo,
        amount: "",
        createdAt: sv.createdAt,
        type: NotificationType.siteVisit,
        senderUserName: sv.senderUserName,
        actionType: sv.actionType,
        originalModel: sv,
      ));
    }

    for (final MeetingHistoryModel m in meetingProvider.historyList) {
      allItems.add(NotificationItem(
        id: m.id,
        clientName: m.clientName,
        projectNo: m.projectNo,
        amount: "",
        createdAt: m.createdAt,
        type: NotificationType.meeting,
        clientOrAgency: m.clientOrAgency,
        agencyName: m.agencyName,
        meetingDate: m.meetingDate,
        meetingTime: m.meetingTime,
        senderUserName: m.senderUserName,
        actionType: m.actionType,
        originalModel: m,
      ));
    }

    for (final SelectionHistoryModel s in selectionProvider.historyList) {
      allItems.add(NotificationItem(
        id: s.id,
        clientName: s.clientName,
        projectNo: s.projectNo,
        amount: "",
        createdAt: s.createdAt,
        type: NotificationType.selection,
        selectionDate: s.selectionDate,
        selectionTime: s.selectionTime,
        senderUserName: s.senderUserName,
        actionType: s.actionType,
        originalModel: s,
      ));
    }

    for (final OfferLetterHistoryModel o in offerProvider.historyList) {
      allItems.add(NotificationItem(
        id: o.id,
        clientName: o.clientName,
        projectNo: "",
        amount: "",
        contactNo: o.contactNo,
        location: o.location,
        offerType: o.offerType,
        createdAt: o.createdAt,
        type: NotificationType.offerLetter,
        senderUserName: o.senderUserName,
        actionType: o.actionType,
        originalModel: o,
      ));
    }

    for (final DiscussionHistoryModel d in discussionProvider.historyList) {
      allItems.add(NotificationItem(
        id: d.id,
        clientName: d.clientName,
        projectNo: d.projectNo,
        amount: "",
        createdAt: d.createdAt,
        discussionDate: d.discussionDate,
        discussionTime: d.discussionTime,
        discussionFrom: d.discussionFrom,
        type: NotificationType.discussion,
        senderUserName: d.senderUserName,
        actionType: d.actionType,
        originalModel: d,
      ));
    }

    // Sort newest first
    allItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Filter by search query (Client name, Project No, Invoice No, Contact No, Invoice Type, Sender name, Amount, or Date)
    final filteredList = allItems.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      final name = item.clientName.toLowerCase();
      final project = item.projectNo.toLowerCase();
      final invoice = (item.invoiceNo ?? "").toLowerCase();
      final contact = (item.contactNo ?? "").toLowerCase();
      final invoiceType = (item.invoiceType ?? "").toLowerCase();
      final paymentStatus = (item.paymentStatus ?? "").toLowerCase();
      final mode = (item.paymentMode ?? "").toLowerCase();
      final sender = (item.senderUserName ?? "").toLowerCase();
      final amount = item.amount.toLowerCase();
      final agency = (item.agencyName ?? "").toLowerCase();
      final offer = (item.offerType ?? "").toLowerCase();
      final dateFormatted = _formatDateTime(item.createdAt).toLowerCase();

      String typeLabel = "";
      switch (item.type) {
        case NotificationType.invoice:
          typeLabel = "invoice ${item.invoiceType ?? ''}".toLowerCase();
          break;
        case NotificationType.received:
          typeLabel = "received";
          break;
        case NotificationType.reminder:
          typeLabel = "reminder";
          break;
        case NotificationType.siteVisit:
          typeLabel = "site visit";
          break;
        case NotificationType.meeting:
          typeLabel = "meeting";
          break;
        case NotificationType.selection:
          typeLabel = "selection";
          break;
        case NotificationType.offerLetter:
          typeLabel = "offer letter ${item.offerType ?? ''}".toLowerCase();
          break;
        case NotificationType.discussion:
          typeLabel = "discussion";
          break;
      }

      return name.contains(q) ||
          project.contains(q) ||
          invoice.contains(q) ||
          contact.contains(q) ||
          invoiceType.contains(q) ||
          paymentStatus.contains(q) ||
          mode.contains(q) ||
          sender.contains(q) ||
          amount.contains(q) ||
          agency.contains(q) ||
          offer.contains(q) ||
          dateFormatted.contains(q) ||
          typeLabel.contains(q);
    }).toList();

    // Paginated list based on _displayedCount
    final paginatedList = filteredList.take(_displayedCount).toList();
    final bool hasMore = filteredList.length > paginatedList.length;

    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: PickColors.hintColor),
        centerTitle: true,
        backgroundColor: PickColors.whiteColor,
        elevation: 0,
        title: Text(
          "Notifications",
          style: CommonTextStyle().appBarTextStyle,
        ),
      ),
      body: reminderProvider.isLoading && allItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                if (allItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: PickColors.secondaryBGColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: PickColors.textfieldBorderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _displayedCount = _pageSize;
                          });
                        },
                        style: CommonTextStyle().textFieldTitleTextStyle,
                        decoration: InputDecoration(
                          hintText: "Search by client name, project no, sender...",
                          hintStyle: CommonTextStyle().authSubTitleTextStyle.copyWith(fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = "";
                                      _displayedCount = _pageSize;
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),

                // Main Content List
                Expanded(
                  child: RefreshIndicator(
                    color: PickColors.primaryColor,
                    backgroundColor: PickColors.whiteColor,
                    onRefresh: _handleRefresh,
                    child: allItems.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.55,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_off_outlined,
                                        size: 56,
                                        color: PickColors.primaryColor,
                                      ),
                                      PickHeightAndWidth.height12,
                                      Text(
                                        "No notifications yet",
                                        style: CommonTextStyle().homeFlowTitleTextStyle.copyWith(fontSize: 15),
                                      ),
                                      PickHeightAndWidth.height5,
                                      Text(
                                        "Fees Reminder, Received & Invoices will appear here",
                                        style: CommonTextStyle().authSubTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : filteredList.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.55,
                                    child: Center(
                                      child: Text(
                                        "No results found for \"$_searchQuery\"",
                                        style: CommonTextStyle().authSubTitleTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                                itemCount: paginatedList.length + (hasMore ? 1 : 0),
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  if (index == paginatedList.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.0),
                                      child: Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                    );
                                  }

                                  final NotificationItem item = paginatedList[index];
                                  final bool isReceived = item.type == NotificationType.received;
                                  final bool isInvoice = item.type == NotificationType.invoice;
                                  final bool isSiteVisit = item.type == NotificationType.siteVisit;
                                  final bool isMeeting = item.type == NotificationType.meeting;
                                  final bool isSelection = item.type == NotificationType.selection;
                                  final bool isOfferLetter = item.type == NotificationType.offerLetter;
                                  final bool isDiscussion = item.type == NotificationType.discussion;

                                  final String senderName = (item.senderUserName != null && item.senderUserName!.trim().isNotEmpty)
                                      ? item.senderUserName!.trim()
                                      : "User";

                                  String actionText;
                                  if (isInvoice || isSiteVisit || isSelection || (isOfferLetter && item.actionType == "exported_pdf")) {
                                    actionText = "Exported PDF";
                                  } else {
                                    actionText = item.actionType == "shared" ? "Shared" : "Copied";
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: PickColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: PickColors.textfieldBorderColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.02),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header row: Compact Icon, Name, Badge, Date, Delete Button
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: isMeeting
                                                      ? Colors.blue.shade50
                                                      : (isSelection
                                                          ? Colors.indigo.shade50
                                                          : (isOfferLetter
                                                              ? (item.offerType == "Interior" ? Colors.amber.shade50 : Colors.cyan.shade50)
                                                              : (isDiscussion
                                                                  ? Colors.deepOrange.shade50
                                                                  : (isSiteVisit
                                                                      ? Colors.teal.shade50
                                                                      : (isInvoice
                                                                          ? Colors.purple.shade50
                                                                          : (isReceived
                                                                              ? Colors.green.shade50
                                                                              : PickColors.primaryColor.withOpacity(0.12))))))),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: isMeeting
                                                    ? SvgPicture.asset(
                                                        PickImages.meetingIcon,
                                                        height: 18,
                                                        width: 18,
                                                      )
                                                    : (isSelection
                                                        ? SvgPicture.asset(
                                                            PickImages.selectionIcon,
                                                            height: 18,
                                                            width: 18,
                                                          )
                                                        : (isOfferLetter
                                                            ? SvgPicture.asset(
                                                                item.offerType == "Interior"
                                                                    ? PickImages.interiorOfferLetterIcon
                                                                    : PickImages.architectureOfferLetterIcon,
                                                                height: 18,
                                                                width: 18,
                                                              )
                                                            : (isDiscussion
                                                                ? SvgPicture.asset(
                                                                    PickImages.messageReplyIcon,
                                                                    height: 18,
                                                                    width: 18,
                                                                  )
                                                                : (isSiteVisit
                                                                    ? SvgPicture.asset(
                                                                        PickImages.siteVisitIcon,
                                                                        height: 18,
                                                                        width: 18,
                                                                      )
                                                                    : (isInvoice
                                                                        ? ((item.invoiceType != null && item.invoiceType!.toLowerCase().contains("gst"))
                                                                            ? SvgPicture.asset(
                                                                                PickImages.gstInvoiceIcon,
                                                                                height: 18,
                                                                                width: 18,
                                                                              )
                                                                            : ((item.invoiceType != null &&
                                                                                    (item.invoiceType!.toLowerCase().contains("art") ||
                                                                                        item.invoiceType!.toLowerCase().contains("shopy") ||
                                                                                        item.invoiceType!.toLowerCase().contains("shophy")))
                                                                                ? ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(4),
                                                                                    child: Image.asset(
                                                                                      PickImages.artOShophyLogoImage,
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  )
                                                                                : ((item.invoiceType != null &&
                                                                                        item.invoiceType!.toLowerCase().contains("alekha"))
                                                                                    ? ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(4),
                                                                                        child: Image.asset(
                                                                                          PickImages.alekhaLogo,
                                                                                          height: 20,
                                                                                          width: 20,
                                                                                          fit: BoxFit.contain,
                                                                                        ),
                                                                                      )
                                                                                    : SvgPicture.asset(
                                                                                        PickImages.invoiceIcon,
                                                                                        height: 18,
                                                                                        width: 18,
                                                                                      ))))
                                                                        : SvgPicture.asset(
                                                                            isReceived
                                                                                ? PickImages.feeReceivedIcon
                                                                                : PickImages.feeReminderIcon,
                                                                            height: 18,
                                                                            width: 18,
                                                                          )))))),
                                              ),
                                            PickHeightAndWidth.width10,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.clientName.isNotEmpty ? item.clientName : "Client",
                                                    style: CommonTextStyle().homeFlowTitleTextStyle.copyWith(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    _formatDateTime(item.createdAt),
                                                    style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                                                          fontSize: 10.5,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (isInvoice && item.paymentStatus != null && item.paymentStatus!.isNotEmpty) ...[
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  color: item.paymentStatus == 'Fees Paid'
                                                      ? Colors.green.shade50
                                                      : Colors.red.shade50,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: item.paymentStatus == 'Fees Paid'
                                                        ? Colors.green.shade300
                                                        : Colors.red.shade200,
                                                  ),
                                                ),
                                                child: Text(
                                                  item.paymentStatus!,
                                                  style: TextStyle(
                                                    color: item.paymentStatus == 'Fees Paid'
                                                        ? Colors.green.shade800
                                                        : Colors.red.shade800,
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                              decoration: BoxDecoration(
                                                color: isOfferLetter
                                                    ? (item.offerType == "Interior" ? Colors.amber.shade50 : Colors.cyan.shade50)
                                                    : (isDiscussion
                                                        ? Colors.deepOrange.shade50
                                                        : (isMeeting
                                                            ? Colors.blue.shade50
                                                            : (isSelection
                                                                ? Colors.indigo.shade50
                                                                : (isSiteVisit
                                                                    ? Colors.teal.shade50
                                                                    : (isInvoice
                                                                        ? Colors.purple.shade50
                                                                        : (isReceived ? Colors.green.shade50 : Colors.orange.shade50)))))),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isOfferLetter
                                                      ? (item.offerType == "Interior" ? Colors.amber.shade400 : Colors.cyan.shade400)
                                                      : (isDiscussion
                                                          ? Colors.deepOrange.shade300
                                                          : (isMeeting
                                                              ? Colors.blue.shade300
                                                              : (isSelection
                                                                  ? Colors.indigo.shade300
                                                                  : (isSiteVisit
                                                                      ? Colors.teal.shade300
                                                                      : (isInvoice
                                                                          ? Colors.purple.shade300
                                                                          : (isReceived ? Colors.green.shade300 : Colors.orange.shade200)))))),
                                                ),
                                              ),
                                              child: Text(
                                                isOfferLetter
                                                    ? "${item.offerType ?? ''} Offer"
                                                    : (isDiscussion
                                                        ? "Discussion"
                                                        : (isMeeting
                                                            ? "Meeting"
                                                            : (isSelection
                                                                ? "Selection"
                                                                : (isSiteVisit
                                                                    ? "Site Visit"
                                                                    : (isInvoice
                                                                        ? (item.invoiceType?.isNotEmpty == true ? item.invoiceType! : "Invoice")
                                                                        : (isReceived ? "Received" : "Reminder")))))),
                                                style: TextStyle(
                                                  color: isOfferLetter
                                                      ? (item.offerType == "Interior" ? Colors.amber.shade900 : Colors.cyan.shade900)
                                                      : (isDiscussion
                                                          ? Colors.deepOrange.shade900
                                                          : (isMeeting
                                                              ? Colors.blue.shade800
                                                              : (isSelection
                                                                  ? Colors.indigo.shade800
                                                                  : (isSiteVisit
                                                                      ? Colors.teal.shade800
                                                                      : (isInvoice
                                                                          ? Colors.purple.shade800
                                                                          : (isReceived ? Colors.green.shade800 : Colors.orange.shade800)))))),
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            // Delete icon for particular notification
                                            InkWell(
                                              onTap: () => _confirmDelete(context, item),
                                              borderRadius: BorderRadius.circular(20),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 19,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 14, thickness: 0.7),
                                        // Details row
                                        if (isSiteVisit) ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: "Project No.",
                                                  value: item.projectNo.isNotEmpty ? item.projectNo : "-",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else if (isSelection) ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: "Project No.",
                                                  value: item.projectNo.isNotEmpty ? item.projectNo : "-",
                                                ),
                                              ),
                                              if (item.selectionDate != null && item.selectionDate!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Selection Date",
                                                    value: item.selectionDate!,
                                                  ),
                                                ),
                                              if (item.selectionTime != null && item.selectionTime!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Selection Time",
                                                    value: item.selectionTime!,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ] else if (isOfferLetter) ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: "Client Name",
                                                  value: item.clientName.isNotEmpty ? item.clientName : "-",
                                                ),
                                              ),
                                              if (item.contactNo != null && item.contactNo!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Contact No.",
                                                    value: item.contactNo!,
                                                  ),
                                                ),
                                              if (item.location != null && item.location!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Location",
                                                    value: item.location!,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ] else if (isDiscussion) ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: "Project No.",
                                                  value: item.projectNo.isNotEmpty ? item.projectNo : "-",
                                                ),
                                              ),
                                              if (item.discussionDate != null && item.discussionDate!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Discussion Date",
                                                    value: item.discussionDate!,
                                                  ),
                                                ),
                                              if (item.discussionTime != null && item.discussionTime!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Discussion Time",
                                                    value: item.discussionTime!,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (item.discussionFrom != null && item.discussionFrom!.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "From",
                                                    value: item.discussionFrom!,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ] else if (isMeeting) ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: "Project No.",
                                                  value: item.projectNo.isNotEmpty ? item.projectNo : "-",
                                                ),
                                              ),
                                              if (item.meetingDate != null && item.meetingDate!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Meeting Date",
                                                    value: item.meetingDate!,
                                                  ),
                                                ),
                                              if (item.meetingTime != null && item.meetingTime!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Meeting Time",
                                                    value: item.meetingTime!,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (item.agencyName != null && item.agencyName!.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Agency Name",
                                                    value: item.agencyName!,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ] else ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: isInvoice ? "Invoice No." : "Project No.",
                                                  value: isInvoice
                                                      ? (item.invoiceNo?.isNotEmpty == true ? item.invoiceNo! : "-")
                                                      : (item.projectNo.isNotEmpty ? item.projectNo : "-"),
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildInfoItem(
                                                  label: isInvoice
                                                      ? "Total Amount"
                                                      : (isReceived ? "Amount Received" : "Amount Pending"),
                                                  value: item.amount.isNotEmpty ? (isInvoice ? item.amount : "Rs. ${item.amount}"): "-",
                                                  valueColor: isInvoice
                                                      ? Colors.purple.shade700
                                                      : (isReceived ? Colors.green.shade700 : Colors.red.shade700),
                                                ),
                                              ),
                                              if (isReceived && item.paymentMode != null && item.paymentMode!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Payment Mode",
                                                    value: item.paymentMode!,
                                                  ),
                                                )
                                              else if (!isInvoice && item.invoiceNo != null && item.invoiceNo!.isNotEmpty)
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    label: "Invoice No",
                                                    value: item.invoiceNo!,
                                                  ),
                                                )
                                              else if (isInvoice) ...[
                                                if (item.projectNo.isNotEmpty)
                                                  Expanded(
                                                    child: _buildInfoItem(
                                                      label: "Project No.",
                                                      value: item.projectNo,
                                                    ),
                                                  ),
                                                if (item.contactNo != null && item.contactNo!.isNotEmpty)
                                                  Expanded(
                                                    child: _buildInfoItem(
                                                      label: "Contact No.",
                                                      value: item.contactNo!,
                                                    ),
                                                  ),
                                              ],
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        // Prominent Sender Info Badge: Kis user ne action kiya
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: PickColors.secondaryBGColor,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: PickColors.textfieldBorderColor),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isInvoice
                                                    ? Icons.picture_as_pdf_rounded
                                                    : (item.actionType == "shared"
                                                        ? Icons.share_rounded
                                                        : Icons.copy_rounded),
                                                size: 12,
                                                color: PickColors.hintColor,
                                              ),
                                              const SizedBox(width: 5),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: PickColors.hintColor,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "$actionText by: ",
                                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                                    ),
                                                    TextSpan(
                                                      text: senderName,
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    Color? valueColor,
    int flex = 1,
  }) {
    return Tooltip(
      message: "$label: $value",
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 3),
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: CommonTextStyle().authSubTitleTextStyle.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: CommonTextStyle().textFieldTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: valueColor ?? PickColors.hintColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
