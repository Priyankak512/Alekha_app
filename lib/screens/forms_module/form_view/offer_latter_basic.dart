import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BasicOfferLatter extends StatefulWidget {
  const BasicOfferLatter({super.key});

  @override
  State<BasicOfferLatter> createState() => _BasicOfferLatterState();
}

class _BasicOfferLatterState extends State<BasicOfferLatter> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

  TextEditingController projectNumberController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController plotSizeController = TextEditingController();
  TextEditingController threeDElevationController = TextEditingController();
  TextEditingController twoDLayoutOptionsController = TextEditingController();
  TextEditingController twoDRevisionController = TextEditingController();
  TextEditingController threeElevationNoOfSidesController =
      TextEditingController();
  TextEditingController clientRequirementsController = TextEditingController();
  TextEditingController threeDNumberOfElevationController =
      TextEditingController();
  TextEditingController threeDElevationRevisionController =
      TextEditingController();
  TextEditingController twoDLayoutController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String getOfferMessage() {
    String twoDLayoutText = "";
    String threeDLayoutText = "";

    // ================= 2D LAYOUT =================
    if (twoDLayoutOptionsController.text.isNotEmpty ||
        twoDRevisionController.text.isNotEmpty) {
      List<String> twoDDetails = [];

      if (twoDLayoutOptionsController.text.isNotEmpty) {
        twoDDetails.add("${twoDLayoutOptionsController.text} Options");
      }

      if (twoDRevisionController.text.isNotEmpty) {
        twoDDetails.add("${twoDRevisionController.text} Revision");
      }

      twoDLayoutText = """
2D Layout - Rs. ${twoDLayoutController.text.isNotEmpty ? twoDLayoutController.text : "-"} /- (${twoDDetails.join(", ")})
""";
    }

    // ================= 3D ELEVATION =================
    if (threeElevationNoOfSidesController.text.isNotEmpty ||
        threeDNumberOfElevationController.text.isNotEmpty ||
        threeDElevationRevisionController.text.isNotEmpty) {
      List<String> threeDDetails = [];
      if (threeElevationNoOfSidesController.text.isNotEmpty) {
        threeDDetails.add("${threeElevationNoOfSidesController.text} Side");
      }
      if (threeDNumberOfElevationController.text.isNotEmpty) {
        threeDDetails.add("${threeDNumberOfElevationController.text} Options");
      }

      if (threeDElevationRevisionController.text.isNotEmpty) {
        threeDDetails.add("${threeDElevationRevisionController.text} Revision");
      }

      threeDLayoutText = """
3D Elevation - Rs. ${threeDElevationController.text.isNotEmpty ? threeDElevationController.text : "-"} /- (${threeDDetails.join(", ")})
""";
    }

    return """Hi,
${clientNameController.text.isNotEmpty ? clientNameController.text : "-"} - ${contactNoController.text.isNotEmpty ? contactNoController.text : "-"}
${locationController.text.isNotEmpty ? locationController.text : "-"}
Plot Size - ${plotSizeController.text.isNotEmpty ? plotSizeController.text : "-"}

Basic - Professional Fees
$twoDLayoutText$threeDLayoutText
Scope Description
${clientRequirementsController.text.isNotEmpty ? clientRequirementsController.text : ""}
""";
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
              'Offer Letter - Basic',
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
                    controller: clientNameController,
                    labelText: "Client Name",
                    hintText: "Client Name",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: contactNoController,
                    labelText: "Contact No.",
                    hintText: "Contact No.",
                    suffixIcon: InkWell(
                      onTap: () {
                        helper.pickContact(contactNoController);
                      },
                      child: const Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: locationController,
                    labelText: "Location",
                    hintText: "Location",
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
                  CommonTextFieldWithFocus(
                    controller: plotSizeController,
                    labelText: "Plot size",
                    hintText: "Plot size",
                  ),
                  PickHeightAndWidth.height20,
                  Text("Professional Fees - Basic".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  CommonTextFieldWithFocus(
                    controller: twoDLayoutController,
                    labelText: "2D layout charges",
                    hintText: "2D layout charges",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: threeDElevationController,
                    labelText: "3D elevation charges",
                    hintText: "3D elevation charges",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("Details  we provide".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  CommonTextFieldWithFocus(
                    controller: twoDLayoutOptionsController,
                    labelText: "2D layout options",
                    hintText: "2D layout options",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2), // max 2 digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: twoDRevisionController,
                    labelText: "2D layout revision",
                    hintText: "2D layout revision",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2), // max 2 digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: threeElevationNoOfSidesController,
                    labelText: "3D elevation no. of sides",
                    hintText: "3D elevation no. of sides",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2), // max 2 digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: threeDNumberOfElevationController,
                    labelText: "3D elevation options",
                    hintText: "3D elevation options",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2), // max 2 digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: threeDElevationRevisionController,
                    labelText: "3D elevation revision",
                    hintText: "3D elevation revision",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2), // max 2 digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  Text("SCOPE DESCRIBED BY CLIENT",
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  // CommonTextFieldWithFocus(
                  //   controller: clientRequirementsController,
                  //   maxLines: 10,
                  //   labelText: "Client requirements",
                  //   hintText: "Client requirements",
                  //   keyboardType: TextInputType.name,
                  // ),
                   CommonTextFieldWithFocus(
                    controller: clientRequirementsController,
                    labelText: "Client requirements",
                    hintText: "Client requirements",
                    maxLines: 5,
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
                      getOfferMessage(),
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
                            // final message = getDiscussionMessage();
                            // shareOnWhatsApp(message);
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
                              ClipboardData(text: getOfferMessage()),
                            );
                            String message = getOfferMessage();
                            Clipboard.setData(ClipboardData(
                                text: message)); // Copy to clipboard

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
