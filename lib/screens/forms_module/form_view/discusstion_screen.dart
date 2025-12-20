import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  // String? _selectedMeetingType;
  String? _selectedRegardsType;
  String? _selectedFromType;
  // String? _selectedTimeStatus;
  // bool isAgencySelected = false;
  // bool isClientSelected = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController projectCategoryController = TextEditingController();

  // TextEditingController siteNameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationMeetingController = TextEditingController();
  TextEditingController meetingPurposeController = TextEditingController();

  /// 🔹 Dynamic Meeting Message
  String getDiscussionMessage() {
    return """Hi,
${nameController.text.isNotEmpty ? nameController.text : "-"}
${projectNumberController.text.isNotEmpty ? "Project No. ${projectNumberController.text}" : "Project No. -"}

We had a discussion on ${dateController.text.isNotEmpty ? dateController.text : "-"} at ${timeController.text.isNotEmpty ? timeController.text : "-"} at ${_selectedFromType ?? "-"}.
Description are as follows :
${descriptionController.text.isNotEmpty ? descriptionController.text : "-"}

Regards
${_selectedRegardsType ?? "-"}
âlekha architects
""";
  }

  _launchWhatsapp() async {
    final Uri whatsappUrl = Uri.parse(
      "whatsapp://send?phone=+919512738943&text=${Uri.encodeComponent(getDiscussionMessage())}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp not installed")),
      );
    }
  }

  bool _showPreviewMessage = false; // Visibility flag for the message

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
              'Discussion',
              style: CommonTextStyle().appBarTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  CommonTextFieldWithFocus(
                    controller: nameController,
                    labelText: "Name",
                    hintText: "Enter Name",
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: projectNumberController,
                    labelText: "Project No.",
                    hintText: "Project No.",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: projectCategoryController,
                    labelText: "Project Category",
                    hintText: "Project Category",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CommonTextFieldWithBorder(
                    fillColor: Colors.transparent,
                    filled: true,
                    prefix: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Icon(Icons.calendar_month_outlined,
                          color: PickColors.primaryColor),
                    ),
                    isRequired: true,
                    readOnly: true,
                    hint: "Date",
                    controller: dateController,
                    textInputAction: TextInputAction.none,
                    keyboardType: TextInputType.none,
                    validator: (value) {
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await getDateFunction(
                        isOldDate: false,
                        context: context,
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormate.normalDateFormate.format(pickedDate);
                        dateController.text =
                            formattedDate; // Set the picked date
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTimePickerField(
                    controller: timeController,
                    hintText: 'Time',
                    labelText: 'Time',
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "From",
                    name: 'From',
                    items: GlobalList.discussionFromList
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
                    initialValue: _selectedFromType,
                    onChanged: (newValue) {
                      setState(
                        () {
                          _selectedFromType = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedFromType");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: descriptionController,
                    labelText: "Description",
                    hintText: "Description",
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                      setState(
                        () {
                          _selectedRegardsType = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedRegardsType");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonMaterialButton(
                      title: "Create Message",
                      onPressed: () {
                        setState(() {
                          _showPreviewMessage = true;
                        });
                      }),
                  const SizedBox(height: 10),
                  // if (_showPreviewMessage)
                  //   Text(
                  //     "Hi,\n${siteNameController.text.isNotEmpty ? siteNameController.text : "-"}\n\nâlekha architects is confirming our upcoming meeting scheduled on ${dateMeetingController.text.isNotEmpty ? dateMeetingController.text : "-"} at ${timeMeetingController.text.isNotEmpty ? timeMeetingController.text : "-"} ${_selectedTimeStatus ?? "-"} at ${locationMeetingController.text.isNotEmpty ? locationMeetingController.text : "-"}. For Project No. ${projectNumberController.text.isNotEmpty ? projectNumberController.text : "-"} ${_selectedMeetingType != null ? _selectedMeetingType!.split(" - ").last.trim() : "-"}. Meeting purpose would be as follows : ${meetingPurposeController.text.isNotEmpty ? meetingPurposeController.text : "-"}.\n\nIf you require any additional information before our meeting. Please feel free to contact.\n\nRegards\n${_selectedRegardsType ?? "-"}\nâlekha architects",
                  //     // "Selected Regards: $_selectedRegardsType ${siteNameController.text}",
                  //     style: CommonTextStyle().authSubTitleTextStyle,
                  //   ),

                  if (_showPreviewMessage)
                    Text(
                      getDiscussionMessage(),
                      style: CommonTextStyle().authSubTitleTextStyle,
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonMaterialButton(
                          color: PickColors.successColor,
                          title: "Share",
                          suffixIcon: PickImages.whatsAppIcon,
                          onPressed: () {
                            _launchWhatsapp();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CommonMaterialButton(
                          borderColor: PickColors.authSubTitleTextColor,
                          title: "Copy",
                          suffixIcon: PickImages.persionMailIcon,
                          style: CommonTextStyle().buttonTextStyle,
                          color: PickColors.transparentColor,
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: getDiscussionMessage()),
                            );
                            // String message =
                            //     "Hi,\n${siteNameController.text.isNotEmpty ? siteNameController.text : "-"}\n\nâlekha architects is confirming our upcoming meeting scheduled on ${dateMeetingController.text.isNotEmpty ? dateMeetingController.text : "-"} at ${timeMeetingController.text.isNotEmpty ? timeMeetingController.text : "-"} ${_selectedTimeStatus ?? "-"} at ${locationMeetingController.text.isNotEmpty ? locationMeetingController.text : "-"}. For Project No. ${projectNumberController.text.isNotEmpty ? projectNumberController.text : "-"} ${_selectedMeetingType != null ? _selectedMeetingType!.split(" - ").last.trim() : "-"}. Meeting purpose would be as follows : ${meetingPurposeController.text.isNotEmpty ? meetingPurposeController.text : "-"}.\n\nIf you require any additional information before our meeting. Please feel free to contact.\n\nRegards\n${_selectedRegardsType ?? "-"}\nâlekha architects";

                            // Clipboard.setData(ClipboardData(
                            //     text: message)); // Copy to clipboard

                            // Show a snackbar to confirm the text has been copied
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Message copied to clipboard!"),
                              ),
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
        ),
      );
    });
  }
}

//Date Validation
class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits

    if (text.length > 4) {
      text = text.substring(0, 4); // Restrict to max 4 digits
    }

    String formatted = "";

    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        formatted += ":"; // Add ":" after 2 digits
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
