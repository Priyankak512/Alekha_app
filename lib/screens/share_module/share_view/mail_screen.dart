import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<MailScreen> {
  TextEditingController nameController = TextEditingController();
  String? _selectedRegardsType;
  bool _showPreviewMessage = false;

  final Uri _mapUrl = Uri.parse("https://maps.app.goo.gl/yyvjEDHmwLHJmLor8");

  Future<void> _launchMapUrl() async {
    if (await canLaunchUrl(_mapUrl)) {
      await launchUrl(_mapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_mapUrl';
    }
  }

  List<InlineSpan> buildMessageSpans(String name, String regards) {
    return [
      TextSpan(
          text:
              "Dear $name,\n\nThank you for sending us your product/service catalogue. We have reviewed it and are impressed with the range of products/services you offer.\n\nWhile we do not have any immediate requirements, we will definitely keep your company in mind for future projects. We look forward to the possibility of working with you then.\n\nBest regards,\n\nAr. Ronak S. Jain\nAr. Tushar N. Kachhadiya\n"),
      TextSpan(
        text: "âlekha architects\n\n",
        style: CommonTextStyle().authSubTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
      const TextSpan(text: '\n\nYou can also follow us on'),
      TextSpan(
        text: "\nGoogle\n",
        style: CommonTextStyle().authSubTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
      WidgetSpan(
        child: GestureDetector(
          onTap: _launchMapUrl,
          child: Text(
            'https://g.page/r/CW_ASWsGtudcEA0',
            style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ),
      TextSpan(
        text: "\n\nInstagram \n",
        style: CommonTextStyle().authSubTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
      WidgetSpan(
        child: GestureDetector(
          onTap: _launchMapUrl,
          child: Text(
            'https://www.instagram.com/alekha_architects',
            style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ),
    ];
  }

// ये नया function सिर्फ clipboard के लिए है (plain text)
// RichText के same text के हिसाब से
  String buildClipboardMessage(String name, String regards) {
    return """Dear $name,

Thank you for sending us your product/service catalogue. We have reviewed it and are impressed with the range of products/services you offer.

While we do not have any immediate requirements, we will definitely keep your company in mind for future projects. We look forward to the possibility of working with you then.

Best regards,

Ar. Ronak S. Jain
Ar. Tushar N. Kachhadiya
âlekha architects


You can also follow us on
Google
https://g.page/r/CW_ASWsGtudcEA0

Instagram
https://www.instagram.com/alekha_architects
""";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return WillPopScope(
        onWillPop: () => helper.onWillPop(context),
        child: Scaffold(
          backgroundColor: PickColors.whiteColor,
          appBar: AppBar(
            backgroundColor: PickColors.whiteColor,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                backToScreen(context: context);
              },
              child: Icon(
                Icons.arrow_left_outlined,
                size: 35,
                color: PickColors.hintColor,
              ),
            ),
            automaticallyImplyLeading: false,
            title: Text(
              'Message',
              style: CommonTextStyle().appBarTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CommonTextFieldWithFocus(
                    controller: nameController,
                    labelText: "Name",
                    hintText: "Name",
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height20,
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonMaterialButton(
                  title: "Create Message",
                  onPressed: () {
                    setState(() {
                      _showPreviewMessage = true;
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (_showPreviewMessage)
                  RichText(
                    text: TextSpan(
                      style: CommonTextStyle().authSubTitleTextStyle,
                      children: buildMessageSpans(
                        nameController.text,
                        _selectedRegardsType.toString(),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        color: PickColors.successColor,
                        title: "Share",
                        prefixIcon: PickImages.whatsAppIcon,
                        onPressed: () async {
                          await helper.shareViaWhatsApp(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CommonMaterialButton(
                        borderColor: PickColors.authSubTitleTextColor,
                        title: "Copy",
                        prefixIcon: PickImages.persionMailIcon,
                        style: CommonTextStyle().buttonTextStyle,
                        color: PickColors.transparentColor,
                        onPressed: () {
                          String message = buildClipboardMessage(
                            nameController.text,
                            _selectedRegardsType.toString(),
                          );

                          Clipboard.setData(ClipboardData(text: message));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Message copied to clipboard!")),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
