import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
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
          'Profile',
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
                }),
            const SizedBox(height: 10),
            if (_showPreviewMessage)
              Text(
                "Hi,\n${nameController.text}\n\nArchitects | Interior Designers | Engineers now in your location.We are team of innovative and certified architects providing all Architectural services like, 3D-2D Floor Plans, 3D Elevations, Structural drawings & inspection, Renovation, Plumbing, Electrical, Flooring & Interior Designing services like, Carpentry, Electrification, False Ceiling, Decor with all necessary detail for Residential, Commercial & Institutional projects.\n\nYou can surely consult us for any of your upcoming Architectural, Interior & Renovation project by contacting us @\n\nAr. Ronak Surendra Jain\n93760 73577\nAr. Tushar Nannubhai Kachhadiya\n87588 23271\n\nHave a look on our Work Profile on Google by saving this contact & then clicking on this link.\n\nhttps://g.page/r/CW_ASWsGtudcEA0\n\nThanks & Regards\nalekha architects",
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
                          "Hi,\n${nameController.text}\n\nArchitects | Interior Designers | Engineers now in your location.We are team of innovative and certified architects providing all Architectural services like, 3D-2D Floor Plans, 3D Elevations, Structural drawings & inspection, Renovation, Plumbing, Electrical, Flooring & Interior Designing services like, Carpentry, Electrification, False Ceiling, Decor with all necessary detail for Residential, Commercial & Institutional projects.\n\nYou can surely consult us for any of your upcoming Architectural, Interior & Renovation project by contacting us @\n\nAr. Ronak Surendra Jain\n93760 73577\nAr. Tushar Nannubhai Kachhadiya\n87588 23271\n\nHave a look on our Work Profile on Google by saving this contact & then clicking on this link.\n\nhttps://g.page/r/CW_ASWsGtudcEA0\n\nThanks & Regards\nalekha architects";
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
