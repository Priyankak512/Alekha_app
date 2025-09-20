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

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<MessageScreen> {
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

// ये function सिर्फ RichText के लिए है (आपका existing code जैसा है)
  List<InlineSpan> buildMessageSpans(String name, String regards) {
    return [
      TextSpan(
          text:
              "Hi,\n$name\nThanks for sharing your service/product content.\n\n"),
      TextSpan(
        text: "âlekha architects, ",
        style: CommonTextStyle().authSubTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
      const TextSpan(
        text:
            "are really looking forward to work with you in upcoming future projects.\n\n"
            "As requirement rises, will surely contact you/your firm.\n\n"
            "Do just share such details for future contact on our Email ID:  ",
      ),
      WidgetSpan(
        child: GestureDetector(
          onTap: _launchMapUrl,
          child: Text(
            'alekhaarchitects@gmail.com',
            style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
          ),
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
      const TextSpan(text: "\n\n\n"),
      TextSpan(text: "Regards\n$regards\n"),
      TextSpan(
        text: "âlekha architects",
        style: CommonTextStyle().authSubTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
    ];
  }

// ये नया function सिर्फ clipboard के लिए है (plain text)
  String buildClipboardMessage(String name, String regards) {
    return """Hi,
$name
Thanks for sharing your service/product content.

âlekha architects,
are really looking forward to work with you in upcoming future projects.

As requirement rises, will surely contact you/your firm.

Do just share such details for future contact on our Email ID: \nalekhaarchitects@gmail.com

You can also follow us on
Google
https://g.page/r/CW_ASWsGtudcEA0

Instagram
https://www.instagram.com/alekha_architects


Regards
$regards
âlekha architects""";
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
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Regards",
                    name: 'Regards',
                    items: GlobalList.regardsName
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                style:
                                    CommonTextStyle().textFieldTitleTextStyle,
                              ),
                            ))
                        .toList(),
                    isExpanded: false,
                    initialValue: _selectedRegardsType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRegardsType = newValue.toString();
                      });
                      debugPrint("----------$_selectedRegardsType");
                    },
                  ),
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

                // if (_showPreviewMessage)
                // RichText(
                //   text: TextSpan(
                //     style: CommonTextStyle().authSubTitleTextStyle,
                //     children: [
                //       TextSpan(
                //           text:
                //               "Hi,\n${nameController.text}\nThanks for sharing your service/product content.\n\n"),
                //       TextSpan(
                //         text: "âlekha architects,",
                //         style:
                //             CommonTextStyle().authSubTitleTextStyle.copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //       ),
                //       const TextSpan(
                //           text:
                //               "are really looking forward to work with you in upcoming future projects.\n\nAs requirement rises, will surely contact you/your firm.\n\nDo just share such details for future contact on our Email ID:  "),
                //       WidgetSpan(
                //         child: GestureDetector(
                //           onTap: _launchMapUrl,
                //           child: Text(
                //             'alekhaarchitects@gmail.com',
                //             style: CommonTextStyle()
                //                 .authSubTitleTextStyle
                //                 .copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue,
                //                   decoration: TextDecoration.underline,
                //                 ),
                //           ),
                //         ),
                //       ),
                //        const TextSpan(text: '\n\nYou can also follow us on'),
                //       TextSpan(
                //         text: "\nGoogle\n",
                //         style:
                //             CommonTextStyle().authSubTitleTextStyle.copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //       ),
                //       WidgetSpan(
                //         child: GestureDetector(
                //           onTap: _launchMapUrl,
                //           child: Text(
                //             'https://g.page/r/CW_ASWsGtudcEA0',
                //             style: CommonTextStyle()
                //                 .authSubTitleTextStyle
                //                 .copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue,
                //                   decoration: TextDecoration.underline,
                //                 ),
                //           ),
                //         ),
                //       ),
                //       TextSpan(
                //         text: "\nInstagram \n",
                //         style:
                //             CommonTextStyle().authSubTitleTextStyle.copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //       ),
                //       WidgetSpan(
                //         child: GestureDetector(
                //           onTap: _launchMapUrl,
                //           child: Text(
                //             'https://www.instagram.com/alekha_architects',
                //             style: CommonTextStyle()
                //                 .authSubTitleTextStyle
                //                 .copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue,
                //                   decoration: TextDecoration.underline,
                //                 ),
                //           ),
                //         ),
                //       ),
                //       const TextSpan(text: "\n\n\n"),
                //       TextSpan(
                //           text:
                //               "Regards\n${_selectedRegardsType.toString()}\n"),
                //       TextSpan(
                //         text: "âlekha architects",
                //         style:
                //             CommonTextStyle().authSubTitleTextStyle.copyWith(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black,
                //                 ),
                //       ),

                //     ],
                //   ),
                // ),

                Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        color: PickColors.successColor,
                        title: "share",
                        prefixIcon: PickImages.whatsAppIcon,
                        onPressed: () {
                          // _launchWhatsapp();
                        },
                      ),
                    ),
                    PickHeightAndWidth.width10,
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
