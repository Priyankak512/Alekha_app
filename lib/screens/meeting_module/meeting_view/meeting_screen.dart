import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  String? _selectedMeetingType;
  String? _selectedRegardsType;
  String? _selectedTimeStatus;

  TextEditingController nameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController timeMeetingController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();
  TextEditingController locationMeetingController = TextEditingController();
  TextEditingController meetingPurposeController = TextEditingController();

  _launchWhatsapp() async {
    var whatsapp = "+919512738943";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  bool _showPreviewMessage = false; // Visibility flag for the message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: PickColors.hintColor,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Meeting',
          style: CommonTextStyle().appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextFieldWithFocus(
                controller: nameController,
                labelText: "Name",
                hintText: "Name",
                keyboardType: TextInputType.name,
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
              CommonDropDownWithoutSearch(
                borderColor: PickColors.primaryColor,
                hintText: "Select project category",
                name: 'Project Category',
                items: GlobalList.projectCategory
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: CommonTextStyle().textFieldTitleTextStyle,
                          ),
                        ))
                    .toList(),
                isExpanded: false,
                initialValue: _selectedMeetingType,
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedMeetingType = newValue.toString();
                    },
                  );
                  debugPrint("----------$_selectedMeetingType");
                },
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
                controller: dateMeetingController,
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
                    dateMeetingController.text =
                        formattedDate; // Set the picked date
                  }
                },
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: timeMeetingController,
                      labelText: "Time",
                      hintText: "Time",
                      inputFormatters: [
                        TimeTextInputFormatter(),
                      ],
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonDropDownWithoutSearch(
                      borderColor: PickColors.secondaryTextColor,
                      hintText: "AM / PM",
                      name: 'AM / PM',
                      items: GlobalList.timeStatus
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
                      initialValue: _selectedTimeStatus,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectedTimeStatus = newValue.toString();
                          },
                        );
                        debugPrint("----------$_selectedTimeStatus");
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: locationMeetingController,
                labelText: "Location",
                hintText: "Location",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: meetingPurposeController,
                labelText: "Meeting Purpose",
                hintText: "Meeting Purpose",
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
                            style: CommonTextStyle().textFieldTitleTextStyle,
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
              if (_showPreviewMessage)
                Text(
                  "Hi,\n${nameController.text.isNotEmpty ? nameController.text : "-"}\n\nâlekha architects is confirming our upcoming meeting scheduled on ${dateMeetingController.text.isNotEmpty ? dateMeetingController.text : "-"} at ${timeMeetingController.text.isNotEmpty ? timeMeetingController.text : "-"} ${_selectedTimeStatus ?? "-"} at ${locationMeetingController.text.isNotEmpty ? locationMeetingController.text : "-"}. For Project No. ${projectNumberController.text.isNotEmpty ? projectNumberController.text : "-"} ${_selectedMeetingType != null ? _selectedMeetingType!.split(" - ").last.trim() : "-"}. Meeting purpose would be as follows : ${meetingPurposeController.text.isNotEmpty ? meetingPurposeController.text : "-"}.\n\nIf you require any additional information before our meeting. Please feel free to contact us at any time\n\nRegards\n${_selectedRegardsType ?? "-"}\nâlekha architects",
                  // "Selected Regards: $_selectedRegardsType ${nameController.text}",
                  style: CommonTextStyle().authSubTitleTextStyle,
                ),
              Row(
                children: [
                  Expanded(
                    child: CommonMaterialButton(
                      color: PickColors.successColor,
                      title: "SHARE ON WHATSAPP",
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
                      title: "COPY TO CLIPBOARD",
                      suffixIcon: PickImages.persionMailIcon,
                      style: CommonTextStyle().buttonTextStyle,
                      color: PickColors.transparentColor,
                      onPressed: () {
                        String message =
                            "Hi,\n${nameController.text.isNotEmpty ? nameController.text : "-"}\n\nâlekha architects is confirming our upcoming meeting scheduled on ${dateMeetingController.text.isNotEmpty ? dateMeetingController.text : "-"} at ${timeMeetingController.text.isNotEmpty ? timeMeetingController.text : "-"} ${_selectedTimeStatus ?? "-"} at ${locationMeetingController.text.isNotEmpty ? locationMeetingController.text : "-"}. For Project No. ${projectNumberController.text.isNotEmpty ? projectNumberController.text : "-"} ${_selectedMeetingType != null ? _selectedMeetingType!.split(" - ").last.trim() : "-"}. Meeting purpose would be as follows : ${meetingPurposeController.text.isNotEmpty ? meetingPurposeController.text : "-"}.\n\nIf you require any additional information before our meeting. Please feel free to contact us at any time\n\nRegards\n${_selectedRegardsType ?? "-"}\nâlekha architects";

                        Clipboard.setData(
                            ClipboardData(text: message)); // Copy to clipboard

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
    );
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
