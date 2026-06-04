import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
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
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FeesReminderScreen extends StatefulWidget {
  const FeesReminderScreen({super.key});

  @override
  State<FeesReminderScreen> createState() => _FeesReminderScreenState();
}

class _FeesReminderScreenState extends State<FeesReminderScreen> {
  String? _selectedProjectCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController feesStageController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController amountPendingController = TextEditingController();
  TextEditingController xxxxController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? _selectedRegardsType;
  bool _showPreviewMessage = false; // Visibility flag for the message
  // Future<void> shareOnWhatsApp(String message) async {
  //   final Uri whatsappUrl = Uri.parse(
  //     "whatsapp://send?text=${Uri.encodeComponent(message)}",
  //   );

  //   if (await canLaunchUrl(whatsappUrl)) {
  //     await launchUrl(whatsappUrl);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("WhatsApp not installed")),
  //     );
  //   }
  // }

  String generateMessage() {
    String name = nameController.text;
    String invoice = invoiceNoController.text;
    String feesStage = feesStageController.text;
    String amount = amountPendingController.text;
    String note = noteController.text;
    String regards = _selectedRegardsType ?? "";

    return '''
Hi,
$name

alekha architects,

Gentle reminder that your fees Rs. $amount is due for project no.${projectController.text} Invoice No. $invoice generated on ${dateMeetingController.text} for fees stage $feesStage. 
Please check the last invoice shared for the same.

${note.trim().isNotEmpty ? 'Note : \n$note\n' : ''}
Regards
$regards
alekha architects
''';
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
                  CommonTextFieldWithFocus(
                    controller: projectController,
                    labelText: "Project No.",
                    hintText: "Project No.",
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height10,
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Select Project category",
                    name: 'Project Category',
                    items: GlobalList.projectCategory
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
                    initialValue: _selectedProjectCategory,
                    onChanged: (newValue) {
                      setState(
                        () {
                          _selectedProjectCategory = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedProjectCategory");
                    },
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: invoiceNoController,
                          labelText: "Invoice No.",
                          hintText: "Invoice No.",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      PickHeightAndWidth.width10,
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
                              String formattedDate = DateFormate
                                  .normalDateFormate
                                  .format(pickedDate);
                              dateMeetingController.text =
                                  formattedDate; // Set the picked date
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: amountPendingController,
                          labelText: "Amount Pending",
                          hintText: "Amount Pending",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      PickHeightAndWidth.width10,
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: feesStageController,
                          labelText: "Fees Stage",
                          hintText: "Fees Stage",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  CommonTextFieldWithFocus(
                    controller: noteController,
                    labelText: "Note",
                    hintText: "Note",
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
                        // TextSpan(
                        //   text: "alekha architects,\n\n",
                        //   style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                        //         fontWeight: FontWeight.bold, // Dark/Bold text
                        //         color: Colors.black, // Ensure it's dark
                        //       ),
                        // ),
                        TextSpan(
                          text:
                              "Gentle reminder that your fees Rs. ${amountPendingController.text} is due for Project No. ${projectController.text} ${_selectedProjectCategory == 'Architecture - A' ? 'A' : _selectedProjectCategory == 'Interior - I' ? 'I' : _selectedProjectCategory == 'Architecture Interior - AI' ? 'AI' : ''} Invoice No. ${invoiceNoController.text} generated on ${dateMeetingController.text} for fees stage ${feesStageController.text}. \nPlease check the last invoice shared for the same.\n\n",
                        ),
                        if (noteController.text.trim().isNotEmpty) ...[
                          TextSpan(text: "Note\n"),
                          TextSpan(text: "${noteController.text}\n\n"),
                        ],
                        // TextSpan(
                        //     text:
                        //         "Gentle reminder that your fees Rs. ${amountPendingController.text}  is due for Invoice No. ${invoiceNoController.text} for fees stage ${feesStageController.text}. \nPlease check the last invoice shared for the same.\n\nNote\n${noteController.text}"),
                        // // "Shop no. 28-29, Hiranagar, nr. old vijay cinema, Bamroli road, Pandesara, Surat\n\nFor exact location please click on the link below:\n\n\n"),
                        TextSpan(
                            text:
                                "\nRegards\n${_selectedRegardsType.toString()}\n"),
                        TextSpan(
                          text: "alekha architects",
                          style:
                              CommonTextStyle().authSubTitleTextStyle.copyWith(
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
                        title: "Share",
                        suffixIcon: PickImages.whatsAppIcon,
                         onPressed: () async {
                          await helper.shareViaWhatsApp(context);
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
                        suffixIcon: PickImages.copyToClipboardIcon,
                        style: CommonTextStyle().buttonTextStyle,
                        color: PickColors.transparentColor,
                        onPressed: () {
                          String message =
                              generateMessage(); // 👈 Generate the message string
                          Clipboard.setData(ClipboardData(
                              text: message)); // 👈 Copy to clipboard

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
    });
  }
}
