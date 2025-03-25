import 'package:alekha/constant/images_route.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
import 'package:alekha/screens/fees_module/fees_view/fees_received_screen.dart';
import 'package:alekha/screens/fees_module/fees_view/fees_reminder_screen.dart';
import 'package:alekha/screens/fees_module/fees_view/fees_screen.dart';
import 'package:alekha/screens/forms_module/form_view/architecture_screen.dart';
import 'package:alekha/screens/forms_module/form_view/form_screen.dart';
import 'package:alekha/screens/forms_module/form_view/interior_screen.dart';
import 'package:alekha/screens/forms_module/form_view/other_forn_screen.dart';
import 'package:alekha/screens/invoice_generator/invoice_generator_view/invoice_generator_screen.dart';
import 'package:alekha/screens/meeting_module/meeting_view/meeting_screen.dart';
import 'package:alekha/screens/selection_module/selection_screen.dart';
import 'package:alekha/screens/share_module/share_view/location_screen.dart';
import 'package:alekha/screens/share_module/share_view/profile_screen.dart';
import 'package:alekha/screens/share_module/share_view/share_sceen.dart';
import 'package:alekha/screens/share_module/share_view/social_screen.dart';

class GlobalList {
  static List<String> projectCategory = [
    "Architecture - A",
    "Interior - I",
    "Architecture Interior - AI"
  ];

  static List<String> regardsName = ["Ar.Tushar Kachhadiya", "Ar.Ronak Jain"];
  static List<String> paymentModeList = ["Cash", "UPI", "Bank Transfer"];

  static List<String> timeStatus = ["AM", "PM"];

  //Home List ===========
  static List homeList = [
    {
      "id": "1",
      "title": "Site Visit",
      "icon": PickImages.siteVisitIcon,
      "screen": const SiteVisitReportScreen(),
    },
    {
      "id": "2",
      "title": "Meeting",
      "icon": PickImages.meetingIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "3",
      "title": "Project Files",
      "icon": PickImages.projectFilesIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "4",
      "title": "Selection",
      "icon": PickImages.selectionIcon,
      "screen": const SelectionScreen(),
    },
    {
      "id": "5",
      "title": "Forms",
      "icon": PickImages.formsIcon,
      "screen": const FormsScreen(),
    },
    {
      "id": "6",
      "title": "Notes",
      "icon": PickImages.notesIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "7",
      "title": "Presentation",
      "icon": PickImages.presentationIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "8",
      "title": "Share",
      "icon": PickImages.shareIcon,
      "screen": const ShareScreen(),
    },
    {
      "id": "9",
      "title": "Fees",
      "icon": PickImages.feesIcon,
      "screen": const FeesScreen(),
    },
    {
      "id": "10",
      "title": "Calculator",
      "icon": PickImages.calculatorIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "11",
      "title": "Compass",
      "icon": PickImages.compassIcon,
      "screen": const MeetingScreen(),
    },
    {
      "id": "12",
      "title": "Draw",
      "icon": PickImages.drawIcon,
      "screen": const MeetingScreen(),
    }
  ];

  //Forms List =======================
  static List formsList = [
    {
      "id": "1",
      "title": "Architecture",
      "icon": PickImages.architectureIcon,
      "screen": const ArchitectureScreen(),
    },
    {
      "id": "2",
      "title": "Interior",  
      "icon": PickImages.meetingIcon,
      "screen": const InteriorScreen(),
    },
    {
      "id": "3",
      "title": "Other",
      "icon": PickImages.projectFilesIcon,
      "screen": const OtherFormsScreen(),
    },
  ];

  //Share List =======================
  static List shareList = [
    {
      "id": "1",
      "title": "Profile",
      "icon": PickImages.siteVisitIcon,
      "screen": const ProfileScreen(),
    },
    {
      "id": "2",
      "title": "Location",
      "icon": PickImages.meetingIcon,
      "screen": const LocationScreen(),
    },
    {
      "id": "3",
      "title": "Social",
      "icon": PickImages.projectFilesIcon,
      "screen": const SocialScreen(),
    },
  ];

  //Social List =======================
  static List socialList = [
    {
      "id": "1",
      "title": "Instagram",
      "icon": PickImages.siteVisitIcon,
      "screen": const ProfileScreen(),
    },
    {
      "id": "2",
      "title": "Facebook",
      "icon": PickImages.meetingIcon,
      "screen": const LocationScreen(),
    },
    {
      "id": "3",
      "title": "Pinterest",
      "icon": PickImages.projectFilesIcon,
      "screen": const SocialScreen(),
    },
    {
      "id": "4",
      "title": "Linkedin",
      "icon": PickImages.siteVisitIcon,
      "screen": const ProfileScreen(),
    },
    {
      "id": "5",
      "title": "Youtube",
      "icon": PickImages.meetingIcon,
      "screen": const LocationScreen(),
    },
    {
      "id": "6",
      "title": "Whatsapp",
      "icon": PickImages.projectFilesIcon,
      "screen": const SocialScreen(),
    },
  ];
  //Fees List =======================
  static List feesList = [
    {
      "id": "1",
      "title": "Invoice",
      "icon": PickImages.siteVisitIcon,
      "screen": const InvoiceGeneratorScreen(),
    },
    {
      "id": "2",
      "title": "Fee Reminder",
      "icon": PickImages.meetingIcon,
      "screen": const FeesReminderScreen(),
    },
    {
      "id": "3",
      "title": "Fee Received",
      "icon": PickImages.projectFilesIcon,
      "screen": const FeesReceivedScreen(),
    },
  ];
}
