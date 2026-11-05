import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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

  Future<void> _shareViaMail() async {
    String message = buildClipboardMessage(
      nameController.text,
      _selectedRegardsType.toString(),
    );

    // Pehle hi clipboard par copy kar dete hain taki user direct paste bhi kar sake
    await Clipboard.setData(ClipboardData(text: message));

    final String subject = Uri.encodeComponent('Regarding Product/Service Catalogue');
    final String body = Uri.encodeComponent(message);

    // "To" ko empty rakha hai taki alekhaarchitects@gmail.com "To" me na aaye.
    // User apne Gmail app me "From" account alekhaarchitects@gmail.com select karke jisko bhejna hai use send kar sake.
    final Uri emailLaunchUri = Uri.parse('mailto:?subject=$subject&body=$body');
    final Uri simpleMailtoUri = Uri.parse('mailto:');

    try {
      // 1. Try launching the mail compose directly
      bool launched = false;
      try {
        launched = await launchUrl(
          emailLaunchUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (err) {
        debugPrint("Direct launch failed: $err");
      }

      // 2. If direct launch failed, try simple mailto
      if (!launched) {
        try {
          launched = await launchUrl(
            simpleMailtoUri,
            mode: LaunchMode.externalApplication,
          );
        } catch (err) {
          debugPrint("Simple mailto failed: $err");
        }
      }

      // 3. Fallback: Share dialog via Share.share
      if (!launched) {
        await Share.share(
          message,
          subject: 'Regarding Product/Service Catalogue',
        );
      } else {
        if (mounted) {
          showToast(
            message: "Opening mail... Message copied to clipboard!",
            isPositive: true,
            context: context,
          );
        }
      }
    } catch (e) {
      debugPrint("Error in _shareViaMail: $e");
      try {
        await Share.share(
          message,
          subject: 'Regarding Product/Service Catalogue',
        );
      } catch (_) {}
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
              'Mail',
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
                        color: PickColors.primaryColor,
                        title: "Share",
                        prefixIcon: PickImages.persionMailIcon,
                        onPressed: () async {
                          await _shareViaMail();
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

                          showToast(message: "Message copied to clipboard!", isPositive: true, context: context);
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
