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
import 'package:alekha/screens/notes_module/notes_view/notes_screen.dart';
import 'package:alekha/screens/project_files_module/project_file_view/project_files_screen.dart';
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

  //Interior List
  static List<String> hiringInteriorDesignerList = [
    "Only Design",
    "Design + Execution",
    "Design + Execution + Material"
  ];
  static List<String> interiorProjectTypeList = [
    "Interior",
    "Renovation",
  ];
  static List<String> interiorCategoryList = [
    "Residential",
    "Retail",
    "Office"
    "Other"
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
      "screen": const ProjectFilesScreen(),
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
      "screen": const NotesScreen(),
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
      "screen": '',
    },
    {
      "id": "11",
      "title": "Compass",
      "icon": PickImages.compassIcon,
      "screen": '',
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
      "icon": PickImages.interiorIcon,
      "screen": const InteriorScreen(),
    },
    {
      "id": "3",
      "title": "Other",
      "icon": PickImages.otherIcon,
      "screen": const OtherFormsScreen(),
    },
  ];

  //Share List =======================
  static List shareList = [
    {
      "id": "1",
      "title": "Profile",
      "icon": PickImages.profileIcon,
      "screen": const ProfileScreen(),
    },
    {
      "id": "2",
      "title": "Location",
      "icon": PickImages.locationIcon,
      "screen": const LocationScreen(),
    },
    {
      "id": "3",
      "title": "Social",
      "icon": PickImages.socialIcon,
      "screen": const SocialScreen(),
    },
  ];

  //Social List =======================
  static List socialList = [
    {
      "id": "7",
      "title": "Google",
      "icon": PickImages.googleIcon,
      "screen": const ProfileScreen(),
      "link": 'https://g.page/r/CW_ASWsGtudcEA0',
    },
    {
      "id": "1",
      "title": "Instagram",
      "icon": PickImages.instagramIcon,
      "screen": const ProfileScreen(),
      "link":
          'https://www.instagram.com/alekha_architects?igsh=MW9zZDNteHgwcWJiMQ==',
    },
    {
      "id": "2",
      "title": "Facebook",
      "icon": PickImages.facebookIcon,
      "screen": const LocationScreen(),
      "link": 'https://m.facebook.com/alekhaarchitects/',
    },
    {
      "id": "3",
      "title": "Pinterest",
      "icon": PickImages.pinterestIcon,
      "screen": const SocialScreen(),
      "link": 'https://pin.it/6MAGQoB',
    },
    {
      "id": "4",
      "title": "Linkedin",
      "icon": PickImages.linkedinIcon,
      "screen": const ProfileScreen(),
      'link':
          'https://www.linkedin.com/in/alekha-architects-74a456178?trk=feed-detail_main-feed-card_feed-actor-name',
    },
    {
      "id": "5",
      "title": "Youtube",
      "icon": PickImages.youtubeIcon,
      "screen": const LocationScreen(),
      'link': 'https://youtube.com/@alekhaarchitects3717?si=Viob3RsCbJpdf1mh',
    },
    {
      "id": "6",
      "title": "Whatsapp",
      "icon": PickImages.whatsAppIcon,
      "screen": const SocialScreen(),
      'link': '',
    },
  ];
  //Fees List =======================
  static List feesList = [
    {
      "id": "1",
      "title": "Invoice",
      "icon": PickImages.invoiceIcon,
      "screen": const InvoiceGeneratorScreen(),
    },
    {
      "id": "2",
      "title": "Fee Reminder",
      "icon": PickImages.feeReminderIcon,
      "screen": const FeesReminderScreen(),
    },
    {
      "id": "3",
      "title": "Fee Received",
      "icon": PickImages.feeReceivedIcon,
      "screen": const FeesReceivedScreen(),
    },
  ];

  //Drive List =======================
  static List projectFilesList = [
    {
      "id": "1",
      "title": "2018 PROJECTS",
      "link": '',
    },
    {
      "id": "2",
      "title": "2019 PROJECTS",
      "link": '',
    },
    {
      "id": "3",
      "title": "2020 PROJECTS",
      "link":
          'https://drive.google.com/drive/folders/1ukuigvz1zphJqUhMzLh-g0R8u-fDt7ee?usp=drive_link'
    },
    {
      "id": "4",
      "title": "2021 PROJECTS",
      "link":
          'https://drive.google.com/drive/folders/1-bwTv0ih6bQtXQAtrtZW-oOd4xGR50gD?usp=drive_link'
    },
    {
      "id": "5",
      "title": "2022 PROJECTS",
      "link":
          'https://drive.google.com/drive/folders/1AR_qwauqLKcJLUlZQ-_uypidVujRKhZX?usp=sharing',
    },
    {
      "id": "6",
      "title": "2023 PROJECTS",
      "link":
          'https://drive.google.com/drive/folders/1A9DJzY49lSDZK7iStogIHQByrTBjG2j4?usp=drive_link',
    },
    {
      "id": "7",
      "title": "2024 PROJECTS",
      "link": '',
    },
    {
      "id": "8",
      "title": "2025 PROJECTS",
      "link": '',
    },
  ];
}
