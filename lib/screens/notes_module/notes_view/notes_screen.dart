import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Notes',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CommonTextFieldWithFocus(
                controller: notesController,
                labelText: "Notes",
                hintText: "Notes",
                maxLines: 10,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
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
                    suffixIcon: PickImages.copyToClipboardIcon,
                    style: CommonTextStyle().buttonTextStyle,
                    color: PickColors.transparentColor,
                    onPressed: () {
                      String message = notesController.text
                          .toString(); // 👈 Generate the message string
                      Clipboard.setData(
                          ClipboardData(text: message)); // 👈 Copy to clipboard

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Message copied to clipboard!"),
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
