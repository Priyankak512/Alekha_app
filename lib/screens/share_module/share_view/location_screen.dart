import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController nameController = TextEditingController();
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
          'Location',
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
                    TextSpan(
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
