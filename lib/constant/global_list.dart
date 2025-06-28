import 'package:alekha/constant/images_route.dart';
import 'package:alekha/screens/calculator_module/calculator_screen.dart';
import 'package:alekha/screens/calculator_module/pythagoras_screen.dart';
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
import 'package:alekha/screens/offer_latter_module/offer_latter_view/offer_latter_screen.dart';
import 'package:alekha/screens/project_files_module/project_file_view/project_files_screen.dart';
import 'package:alekha/screens/selection_module/selection_screen.dart';
import 'package:alekha/screens/share_module/share_view/location_screen.dart';
import 'package:alekha/screens/share_module/share_view/profile_screen.dart';
import 'package:alekha/screens/share_module/share_view/share_sceen.dart';
import 'package:alekha/screens/share_module/share_view/social_screen.dart';
import 'package:flutter/material.dart';

class GlobalList {
  //Offer Letter List
  static List<Map<String, dynamic>> scopOfWorksOfArchitectureOptions = [
    {"id": 1, "title": "Floor Plans", "isChecked": false},
    {"id": 2, "title": "3D Elevation", "isChecked": false},
    {"id": 3, "title": "Structure", "isChecked": false},
    {"id": 4, "title": "Plumbing", "isChecked": false},
    {"id": 5, "title": "Electrical", "isChecked": false},
    {"id": 6, "title": "Door-Window Detail", "isChecked": false},
    {"id": 7, "title": "Toilet Detail", "isChecked": false},
    {"id": 8, "title": "Kitchen Detail", "isChecked": false},
    {"id": 9, "title": "Flooring Detail", "isChecked": false},
    {"id": 10, "title": "Furniture Layout", "isChecked": false},
    {"id": 11, "title": "Ceiling", "isChecked": false},
    {"id": 12, "title": "Interior Electrical", "isChecked": false},
    {"id": 13, "title": "HVAC", "isChecked": false},
    {"id": 14, "title": "Wall Panelling", "isChecked": false},
    {"id": 15, "title": "Color", "isChecked": false},
    {"id": 16, "title": "Decor", "isChecked": false},
    {"id": 17, "title": "Tile/Stone Work", "isChecked": false},
    {"id": 18, "title": "Repair/ Renovate", "isChecked": false},
  ];

  // static List<Map<String, dynamic>> scopOfWorksOfInteriorOptions = [
  //   {"id": 1, "title": "Furniture Layout", "isChecked": false},
  //   {"id": 2, "title": "Ceiling", "isChecked": false},
  //   {"id": 3, "title": "Electrical", "isChecked": false},
  //   {"id": 4, "title": "HVAC", "isChecked": false},
  //   {"id": 5, "title": "Wall Panelling", "isChecked": false},
  //   {"id": 6, "title": "Color", "isChecked": false},
  //   {"id": 7, "title": "Decor", "isChecked": false},
  //   {"id": 8, "title": "Tile/Stone Work", "isChecked": false},
  //   {"id": 9, "title": "Repair/ Renovate", "isChecked": false},
  // ];

  //Professional Fees List
  static List<Map<String, dynamic>> basicOptions = [
    {"id": 1, "title": "2D Layout", "isChecked": false},
    {"id": 2, "title": "3D Elevation", "isChecked": false},
    {"id": 3, "title": "Quotation", "isChecked": false},
    {"id": 4, "title": "Furniture layout", "isChecked": false},
  ];

  static List<Map<String, dynamic>> standardOptions = [
    {"id": 1, "title": "2D Layout", "isChecked": false},
    {"id": 2, "title": "3D Elevation", "isChecked": false},
    {"id": 3, "title": "Structure", "isChecked": false},
    {"id": 4, "title": "Plumbing", "isChecked": false},
    {"id": 5, "title": "Electrical", "isChecked": false},
    {"id": 6, "title": "Site Visit", "isChecked": false},
  ];
  static List<Map<String, dynamic>> premiumOptions = [
    {"id": 1, "title": "2D Layout", "isChecked": false},
    {"id": 2, "title": "3D Elevation", "isChecked": false},
    {"id": 3, "title": "3D Render", "isChecked": false},
    {"id": 4, "title": "Structure", "isChecked": false},
    {"id": 5, "title": "Plumbing", "isChecked": false},
    {"id": 6, "title": "Electrical", "isChecked": false},
    {"id": 7, "title": "All Details", "isChecked": false},
    {"id": 8, "title": "Site & Selection", "isChecked": false},
  ];

  static List<String> projectCategory = [
    "Architecture - A",
    "Interior - I",
    "Architecture Interior - AI"
  ];

  static List<String> scopOfWorkList = [
    "Celling",
    "Electrical",
    "HVAC",
    "Furniture",
    "Wall Panelings",
    "Color"
  ];
  static List<String> feesStatusOptions = ['Fees Paid', 'Fees Unpaid'];
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

  static List drawerList = [
    {
      "id": 1,
      "icon": Icons.language_sharp,
      "title": "Language",
      // "Screen": const SiteVisitReportScreen(),
    },
    {
      "id": 2,
      "icon": Icons.devices,
      "title": "Manage Devices",
      // "Screen": const InvoiceGeneratorScreen(),
    },
    {
      "id": 3,
      "icon": Icons.notification_add_outlined,
      "title": "Notification",
    },
    {
      "id": 4,
      "icon": Icons.mode_night_outlined,
      "title": "Mode",
    },
    {
      "id": 5,
      "icon": Icons.draw_outlined,
      "title": "Artoshophy",
    },
  ];

  static List<String> regardsName = [
    "Ar.Tushar Kachhadiya     ",
    "Ar.Ronak Jain             "
  ];
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
      "screen": const CalculatorScreen(),
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
      "screen": const OfferLetterScreen(),
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
    {
      "id": "4",
      "title": "Offer Letter",
      "icon": PickImages.interiorIcon,
      "screen": const OfferLetterScreen(),
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

//Calculator List =======================
  static List calculatorList = [
    {
      "id": "1",
      "title": "Area-Length",
      "icon": PickImages.areaLengthIcon,
      "screen": null,
    },
    {
      "id": "2",
      "title": "Water Tank",
      "icon": PickImages.waterTankIcon,
      "screen": null,
    },
    {
      "id": "3",
      "title": "Pythagoras",
      "icon": PickImages.pythagorasIcon,
      "screen": const PythagorasScreen(),
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

  //Inch and fit list========================================
  static List inchAndFitList = [
    {
      "id": 1,
      "inch": "1''",
      "title": "0,0833 ft",
    },
    {
      "id": 2,
      "inch": "2''",
      "title": "0,1667 ft",
    },
    {
      "id": 3,
      "inch": "3''",
      "title": "0,2500 ft",
    },
    {
      "id": 4,
      "inch": "4''",
      "title": "0,3333 ft",
    },
    {
      "id": 5,
      "inch": "5''",
      "title": "0,4167 ft",
    },
    {
      "id": 6,
      "inch": "6''",
      "title": "0,5000 ft",
    },
    {
      "id": 7,
      "inch": "7''",
      "title": "0,5833 ft",
    },
    {
      "id": 8,
      "inch": "8''",
      "title": "0,6667 ft",
    },
    {
      "id": 9,
      "inch": "9''",
      "title": "0,7500 ft",
    },
    {
      "id": 10,
      "inch": "10''",
      "title": "0,8333",
    },
    {
      "id": 8,
      "inch": "20''",
      "title": "1,6667 ft",
    },
    {
      "id": 9,
      "inch": "30''",
      "title": "2,5000 ft",
    },
    {
      "id": 10,
      "inch": "40''",
      "title": "3,3333",
    },
  ];
}
