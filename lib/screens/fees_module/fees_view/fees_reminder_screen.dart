import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FeesReminderScreen extends StatefulWidget {
  const FeesReminderScreen({super.key});

  @override
  State<FeesReminderScreen> createState() => _FeesReminderScreenState();
}

class _FeesReminderScreenState extends State<FeesReminderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();
  TextEditingController workStageOnSiteController = TextEditingController();

  String? _selectedRegardsType;
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
          'Fees Reminder',
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
              PickHeightAndWidth.height10,
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: nameController,
                      labelText: "Project No.",
                      hintText: "Project No.",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  PickHeightAndWidth.width10,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: nameController,
                      labelText: "Fees Stage",
                      hintText: "Fees Stage",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
              PickHeightAndWidth.height10,
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWithBorder(
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
                          isOldDate: true,
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
                  ),
                  PickHeightAndWidth.width10,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: nameController,
                      labelText: "Invoice No.",
                      hintText: "Invoice No.",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
              PickHeightAndWidth.height10,
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: nameController,
                      labelText: "Amount Pending",
                      hintText: "Amount Pending",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  PickHeightAndWidth.width10,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: nameController,
                      labelText: "XXXXX ",
                      hintText: "XX",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
              PickHeightAndWidth.height10,
              CommonTextFieldWithFocus(
                controller: workStageOnSiteController,
                labelText: "Work Stage on Site",
                hintText: "Work Stage on Site",
                maxLines: 2,
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
                }),
            const SizedBox(height: 10),
            if (_showPreviewMessage)
              // Text(
              //   "Hi,\n${nameController.text}\n\nalekha architects,\n\nShop no. 28-29, Hiranagar, nr. old vijay cinema, Bamroli road, Pandesara, Surat\n\nFor exact location please click on the link below:\n\n\nRegards\n${_selectedRegardsType.toString()}\nalekha architects",
              //   style: CommonTextStyle().authSubTitleTextStyle,
              // ),
              RichText(
                text: TextSpan(
                  style: CommonTextStyle().authSubTitleTextStyle,
                  children: [
                    TextSpan(text: "Hi,\n${nameController.text}\n\n"),
                    TextSpan(
                      text: "alekha architects,\n\n",
                      style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                            fontWeight: FontWeight.bold, // Dark/Bold text
                            color: Colors.black, // Ensure it's dark
                          ),
                    ),
                    const TextSpan(
                        text:
                            "Shop no. 28-29, Hiranagar, nr. old vijay cinema, Bamroli road, Pandesara, Surat\n\nFor exact location please click on the link below:\n\n\n"),
                    TextSpan(
                        text: "Regards\n${_selectedRegardsType.toString()}\n"),
                    TextSpan(
                      text: "alekha architects",
                      style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: CommonMaterialButton(
                    color: PickColors.successColor,
                    title: "SHARE ON WHATSAPP",
                    suffixIcon: PickImages.whatsAppIcon,
                    onPressed: () {
                      // _launchWhatsapp();
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
                          "Hi,\n${nameController.text}\n\nalekha architects,\n\nShop no. 28-29, Hiranagar, nr. old vijay cinema, Bamroli road, Pandesara, Surat\n\nFor exact location please click on the link below:\n\n\nRegards\n${_selectedRegardsType.toString()}\nalekha architects";
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
    );
  }
}
