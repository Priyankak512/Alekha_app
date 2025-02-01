import 'package:alekha/constant/images_route.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
import 'package:alekha/screens/meeting_module/meeting_view/meeting_screen.dart';
import 'package:alekha/screens/selection_module/selection_screen.dart';

class GlobalList {
  static List<String> projectCategory = [
    "Architecture - A",
    "Interior - I",
    "Architecture Interior - AI"
  ];

  static List<String> regardsName = ["Ar.Tushar Kachhadiya", "Ar.Ronak Jain"];
  static List<String> timeStatus = ["AM", "PM"];
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
      "screen": const MeetingScreen(),
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
      "screen": const MeetingScreen(),
    },
    {
      "id": "9",
      "title": "Fees",
      "icon": PickImages.feesIcon,
      "screen": const MeetingScreen(),
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
}
