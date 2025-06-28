// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/offer_latter_module/offer_latter_widget.dart/textfield_with_cntainer_widget.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as ncp;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class OfferLetterScreen extends StatefulWidget {
  const OfferLetterScreen({super.key});

  @override
  State<OfferLetterScreen> createState() => _OfferLetterScreenState();
}

class _OfferLetterScreenState extends State<OfferLetterScreen> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController basicFeesController = TextEditingController();
  TextEditingController standardFeesController = TextEditingController();
  TextEditingController premiumFeesController = TextEditingController();
  TextEditingController noOfElevationController = TextEditingController();
  TextEditingController noOfRenderController = TextEditingController();
  TextEditingController noOfPremiumCategoryController = TextEditingController();
  TextEditingController noOfStandardCategoryController =
      TextEditingController();
  TextEditingController noOfAdditionalVisitController = TextEditingController();
  TextEditingController layout2DController = TextEditingController();
  TextEditingController revision2DController = TextEditingController();
  TextEditingController elevation3DController = TextEditingController();
  TextEditingController revision3DController = TextEditingController();
  TextEditingController aPremiumController = TextEditingController();
  TextEditingController bPremiumController = TextEditingController();
  TextEditingController cPremiumController = TextEditingController();
  TextEditingController dPremiumController = TextEditingController();
  TextEditingController ePremiumController = TextEditingController();
  TextEditingController fPremiumController = TextEditingController();

  TextEditingController aStandardPremiumController = TextEditingController();
  TextEditingController bStandardPremiumController = TextEditingController();
  TextEditingController cStandardPremiumController = TextEditingController();
  TextEditingController clientRequirementsController = TextEditingController();

  final ncp.FlutterContactPicker _contactPicker = ncp.FlutterContactPicker();
  @override
  void initState() {
    super.initState();
    aPremiumController.addListener(_calculatePremiumTotal);
    bPremiumController.addListener(_calculatePremiumTotal);
    cPremiumController.addListener(_calculatePremiumTotal);
    dPremiumController.addListener(_calculatePremiumTotal);
    ePremiumController.addListener(_calculatePremiumTotal);
    fPremiumController.addListener(_calculatePremiumTotal);

    aStandardPremiumController.addListener(_calculateStandardTotal);
    bStandardPremiumController.addListener(_calculateStandardTotal);
    cStandardPremiumController.addListener(_calculateStandardTotal);
  }

  double _getPremiumTotal() {
    double a = double.tryParse(aPremiumController.text) ?? 0.0;
    double b = double.tryParse(bPremiumController.text) ?? 0.0;
    double c = double.tryParse(cPremiumController.text) ?? 0.0;
    double d = double.tryParse(dPremiumController.text) ?? 0.0;
    double e = double.tryParse(ePremiumController.text) ?? 0.0;
    double f = double.tryParse(fPremiumController.text) ?? 0.0;
    return a + b + c + d + e + f;
  }

  Future<void> _pickContact(TextEditingController controller) async {
    try {
      // Open the contact picker and get the selected contact
      ncp.Contact? contact = await _contactPicker.selectContact();

      // Ensure that the contact and phoneNumbers are not null or empty
      if (contact != null &&
          contact.phoneNumbers != null &&
          contact.phoneNumbers!.isNotEmpty) {
        // Directly access the first phone number (assuming it's a String, not PhoneNumber)
        String contactNumber = contact.phoneNumbers!.first;

        // Set the phone number to the controller's text field
        controller.text = contactNumber.replaceAll(
            RegExp(r'\s+|-'), ''); // Remove spaces or dashes
      }
    } catch (e) {
      print("Error picking contact: $e");
    }
  }

  double _getStandardTotal() {
    double a = double.tryParse(aStandardPremiumController.text) ?? 0.0;
    double b = double.tryParse(bStandardPremiumController.text) ?? 0.0;
    double c = double.tryParse(cStandardPremiumController.text) ?? 0.0;
    return a + b + c;
  }

  TextInputFormatter limitInputBasedOnTotal(
      TextEditingController controller, double Function() getCurrentTotal) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final oldText = oldValue.text;
      final newText = newValue.text;

      // Allow if user is deleting characters
      if (newText.length < oldText.length) return newValue;

      // Parse all values
      double newInput = double.tryParse(newText) ?? 0.0;
      double oldInput = double.tryParse(oldText) ?? 0.0;

      double totalWithoutThis = getCurrentTotal() - oldInput;

      if (totalWithoutThis + newInput > 100) {
        return oldValue; // block input if total exceeds 100
      }

      return newValue; // allow input
    });
  }

  double premiumTotal = 0.0;
  bool isPremiumTotalReached = false;
  void _calculatePremiumTotal() {
    double a = double.tryParse(aPremiumController.text) ?? 0.0;
    double b = double.tryParse(bPremiumController.text) ?? 0.0;
    double c = double.tryParse(cPremiumController.text) ?? 0.0;
    double d = double.tryParse(dPremiumController.text) ?? 0.0;
    double e = double.tryParse(ePremiumController.text) ?? 0.0;

    double sum = a + b + c + d + e;

    if (sum > 100) {
      // Prevent user from entering more
      // Optionally show a warning
      // You can reset last input here or show a dialog
      return;
    }

    setState(() {
      premiumTotal = sum;
      isPremiumTotalReached = sum >= 100;
    });
  }

  double standardTotal = 0.0;
  bool isStandardReached = false;
  void _calculateStandardTotal() {
    double a = double.tryParse(aStandardPremiumController.text) ?? 0.0;
    double b = double.tryParse(bStandardPremiumController.text) ?? 0.0;
    double c = double.tryParse(cStandardPremiumController.text) ?? 0.0;

    double sum = a + b + c;

    if (sum > 100) {
      // Prevent user from entering more
      // Optionally show a warning
      // You can reset last input here or show a dialog
      return;
    }

    setState(() {
      standardTotal = sum;
      isStandardReached = sum >= 100;
    });
  }

  List<Map<String, dynamic>> selectedOptions = [];

// Selected options
  // final selectedOptions = GlobalList.scopOfWorksOfArchitectureOptions
  //     .where((item) => item['isChecked'] == true)
  //     .toList();
//Create PDF :

  Future<void> _generatePDF() async {
    final calibriRegularFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/calibri-regular.ttf'));
    final calibriBoldFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/calibri-bold.ttf'));
    final regularFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Century Gothic.ttf'));
    final boldFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/GOTHICB0.ttf'));
    final pdf = pw.Document();

    Uint8List imageData =
        (await rootBundle.load(PickImages.offerLetterHeaderImage))
            .buffer
            .asUint8List();

    Uint8List offerLaterProcessWorkImage =
        (await rootBundle.load(PickImages.offerLaterProcessWorkImage))
            .buffer
            .asUint8List();
    Uint8List offerLaterScopOfWorkImage =
        (await rootBundle.load(PickImages.offerLaterScopOfWorkImage))
            .buffer
            .asUint8List();

    Uint8List offerLaterFooterImage =
        (await rootBundle.load(PickImages.offerLaterFooterImage))
            .buffer
            .asUint8List();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                height: 100,
                margin: const pw.EdgeInsets.only(bottom: 2),
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(imageData),
                    fit: pw.BoxFit.fitWidth,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                children: [
                  pw.Spacer(),
                  pw.Text(
                    dateController.text,
                    style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.normal,
                        color: PdfColor.fromHex("#616161")),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: buildInlineTextFieldRow(
                        'CLIENT : ',
                        clientNameController.text,
                        calibriBoldFont,
                        calibriRegularFont),
                  ),
                  pw.Expanded(
                    child: buildInlineTextFieldRow(
                      'LOCATION : ',
                      locationController.text,
                      calibriBoldFont,
                      calibriRegularFont,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 10,
                    color: PdfColor.fromHex("#010101"),
                  ),
                  children: [
                    pw.TextSpan(
                      text:
                          "Dear Sir,\nWe are pleased to submit herewith proposal cum contract mentioning detailed scope of work and commercial terms & conditions for your kind perusal & action for your upcoming project. We at ",
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.TextSpan(
                      text: "âlekha architects",
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#000000"),
                      ),
                    ),
                    pw.TextSpan(
                      text:
                          ", are an efficient professional Architectural & Interior Designing firm providing all Architectural, Interior Design, Structural, Civil & services under single roof, with an experienced, qualified & trained team we can assure you best of our services.",
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                " 01. PROCESS OF WORK",
                style: pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                  fontSize: 15,
                  font: calibriBoldFont,
                  // color: PdfColor.fromHex("#000000"),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 300,
                // margin: const pw.EdgeInsets.only(bottom: 2),
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(offerLaterProcessWorkImage),
                    fit: pw.BoxFit.fitWidth,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "02. SCOPE OF WORK - PREMIUM",
                style: pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                  fontSize: 15,
                  font: calibriBoldFont,
                  // color: PdfColor.fromHex("#000000"),
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Container(
                  padding:
                      const pw.EdgeInsets.only(bottom: 10, left: 10, top: 10),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex("#FFFFFF"),
                    borderRadius: pw.BorderRadius.circular(5),
                    border: pw.Border.all(
                        color: PdfColor.fromHex("#BDBDBD"), width: 0.2),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        // padding: const pw.EdgeInsets.all(5),
                        width: 120, // Adjust image width as per your design
                        height: 120,

                        child: pw.Image(
                          pw.MemoryImage(offerLaterScopOfWorkImage),
                          fit: pw.BoxFit.contain,
                        ),
                      ),

                      pw.SizedBox(width: 12), // Spacing between image and grid

                      /// 🔹 RIGHT SIDE GRID CONTAINER
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: List.generate(
                              (selectedOptions.length / 3).ceil(), (rowIndex) {
                            final chunk = selectedOptions
                                .skip(rowIndex * 3)
                                .take(3)
                                .toList();
                            return pw.Row(
                              children: List.generate(3, (colIndex) {
                                if (colIndex < chunk.length) {
                                  return pw.Expanded(
                                    child: pw.Container(
                                        padding: const pw.EdgeInsets.all(6),
                                        margin: const pw.EdgeInsets.all(4),
                                        decoration: pw.BoxDecoration(
                                          color: PdfColor.fromHex("#EBECEC"),
                                          borderRadius:
                                              pw.BorderRadius.circular(5),
                                        ),
                                        alignment: pw.Alignment.center,
                                        // child: pw.Text(
                                        //   chunk[colIndex]['title'],
                                        //   style: pw.TextStyle(
                                        //     font: calibriBoldFont,
                                        //     fontSize: 15,
                                        //   ),
                                        // ),
                                        child: pw.FittedBox(
                                          fit: pw.BoxFit.scaleDown,
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text(
                                            chunk[colIndex]['title'],
                                            style: pw.TextStyle(
                                              font: calibriBoldFont,
                                              fontSize:
                                                  15, // Starting font size, will scale down
                                            ),
                                          ),
                                        )),
                                  );
                                } else {
                                  return pw.Expanded(child: pw.Container());
                                }
                              }),
                            );
                          }),
                        ),
                      ),
                    ],
                  )),
              // pw.SizedBox(height: 30),
              pw.Spacer(),
              // pw.Container(
              //   width: double.infinity,
              //   height: 25,
              //   decoration: pw.BoxDecoration(
              //     image: pw.DecorationImage(
              //       image: pw.MemoryImage(offerLaterFooterImage),
              //       fit: pw.BoxFit.fitWidth,
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );

    // Save and share the generated PDF
    await Printing.layoutPdf(
      name:
          'OFFER LATTER ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

// For inline short fields
  pw.Widget buildInlineTextFieldRow(
      String label, String value, pw.Font font, pw.Font fontAnswer) {
    if (value.isNotEmpty) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                font: font,
                fontSize: 15,
              ),
            ),
            pw.SizedBox(width: 5),
            pw.Expanded(
              child: pw.Text(
                value,
                style: pw.TextStyle(
                  font: fontAnswer,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return pw.SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return SafeArea(
        child: Scaffold(
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
              'Offer Letter',
              style: CommonTextStyle().appBarTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextFieldWithFocus(
                    controller: clientNameController,
                    labelText: "Client Name",
                    hintText: "Client Name",
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height20,
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
                      LengthLimitingTextInputFormatter(12), // Max 10 digits
                      FilteringTextInputFormatter.digitsOnly, // Only digits
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  CommonTextFieldWithFocus(
                    controller: locationController,
                    labelText: "Location",
                    hintText: "Location",
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height20,
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
                        isOldDate: true,
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
                  PickHeightAndWidth.height20,
                  Text("Scope of Work - Architecture & Interior".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  Wrap(
                    spacing: 10.0, // Horizontal spacing
                    runSpacing:
                        -8.0, // Vertical spacing between rows (optional)
                    children: GlobalList.scopOfWorksOfArchitectureOptions
                        .map((option) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 -
                            16, // 2 columns
                        child: CheckboxListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            option['title'],
                            style: CommonTextStyle()
                                .fillableTextFieldTextStyle
                                .copyWith(
                                  fontSize: SizeConfig.fontSize12,
                                ),
                          ),
                          value: option['isChecked'],
                          onChanged: (val) {
                            setState(() {
                              // Count currently selected items
                              final selectedCount = GlobalList
                                  .scopOfWorksOfArchitectureOptions
                                  .where((item) => item['isChecked'] == true)
                                  .length;

                              // If trying to check more than 15, block it
                              if (val == true && selectedCount >= 12) {
                                // Optional: show message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'You can select a maximum of 12 items.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return; // Don't proceed
                              }

                              // Otherwise, update the value
                              option['isChecked'] = val!;
                              selectedOptions = GlobalList
                                  .scopOfWorksOfArchitectureOptions
                                  .where((item) => item['isChecked'] == true)
                                  .toList();
                            });
                          },

                          // onChanged: (val) {
                          //   setState(() {
                          //     option['isChecked'] = val!;

                          //     selectedOptions = GlobalList
                          //         .scopOfWorksOfArchitectureOptions
                          //         .where((item) => item['isChecked'] == true)
                          //         .toList();
                          //   });
                          // },

                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  PickHeightAndWidth.height20,
                  Text("Professional Fees".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  Text("Basic",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  Wrap(
                    spacing: 10.0, // Horizontal spacing
                    runSpacing:
                        -8.0, // Vertical spacing between rows (optional)
                    children: GlobalList.basicOptions.map((option) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 -
                            16, // 2 columns
                        child: CheckboxListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            option['title'],
                            style: CommonTextStyle()
                                .fillableTextFieldTextStyle
                                .copyWith(
                                  fontSize: SizeConfig.fontSize12,
                                ),
                          ),
                          value: option['isChecked'],
                          onChanged: (val) {
                            setState(() {
                              option['isChecked'] = val!;
                            });
                            print("======selected value : ---------${val}");
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  CommonTextFieldWithFocus(
                    controller: basicFeesController,
                    labelText: "Basic - Professional Fees",
                    hintText: "Basic - Professional Fees",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  Text("Standard",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  Wrap(
                    spacing: 10.0, // Horizontal spacing
                    runSpacing:
                        -8.0, // Vertical spacing between rows (optional)
                    children: GlobalList.standardOptions.map((option) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 -
                            16, // 2 columns
                        child: CheckboxListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            option['title'],
                            style: CommonTextStyle()
                                .fillableTextFieldTextStyle
                                .copyWith(
                                  fontSize: SizeConfig.fontSize12,
                                ),
                          ),
                          value: option['isChecked'],
                          onChanged: (val) {
                            setState(() {
                              option['isChecked'] = val!;
                            });
                            print("======selected value : ---------${val}");
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  CommonTextFieldWithFocus(
                    controller: standardFeesController,
                    labelText: "Standard - Professional Fees",
                    hintText: "Standard - Professional Fees",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  Text("Premium",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  Wrap(
                    spacing: 10.0, // Horizontal spacing
                    runSpacing:
                        -8.0, // Vertical spacing between rows (optional)
                    children: GlobalList.premiumOptions.map((option) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 -
                            16, // 2 columns
                        child: CheckboxListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            option['title'],
                            style: CommonTextStyle()
                                .fillableTextFieldTextStyle
                                .copyWith(
                                  fontSize: SizeConfig.fontSize12,
                                ),
                          ),
                          value: option['isChecked'],
                          onChanged: (val) {
                            setState(() {
                              option['isChecked'] = val!;
                            });
                            print("======selected value : ---------${val}");
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  CommonTextFieldWithFocus(
                    controller: premiumFeesController,
                    labelText: "Premium - Professional Fees",
                    hintText: "Premium - Professional Fees",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("Detail We Provide".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  LabelAndTextFieldRow(
                    label: "3D render elevation view",
                    controller: noOfElevationController,
                    labelText: "No. of views",
                    hintText: "No. of views",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  LabelAndTextFieldRow(
                    label: "Additional 3D render view charges",
                    controller: noOfRenderController,
                    labelText: "Changes/view",
                    hintText: "Changes/view",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("Site Visits",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  LabelAndTextFieldRow(
                    label: "Premium category",
                    controller: noOfPremiumCategoryController,
                    labelText: "No. of visits",
                    hintText: "No. of visits",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  LabelAndTextFieldRow(
                    label: "Standard Category",
                    controller: noOfStandardCategoryController,
                    labelText: "No. of visits",
                    hintText: "No. of visits",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  LabelAndTextFieldRow(
                    label: "Additional visit charges",
                    controller: noOfAdditionalVisitController,
                    labelText: "Amount/visit",
                    hintText: "Amount/visit",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("2D Layout",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  LabelAndTextFieldRow(
                    label: "Additional 2D layout",
                    controller: layout2DController,
                    labelText: "Amount/layout",
                    hintText: "Amount/layout",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  LabelAndTextFieldRow(
                    label: "Additional 2D revision",
                    controller: revision2DController,
                    labelText: "Amount/revision",
                    hintText: "Amount/revision",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("3D Elevation",
                      style: CommonTextStyle()
                          .offerLetterTopicNameTextStyle
                          .copyWith(
                            decoration: TextDecoration.none,
                          )),
                  LabelAndTextFieldRow(
                    label: "Additional 3D elevation",
                    controller: elevation3DController,
                    labelText: "Amount/side",
                    hintText: "Amount/side",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height10,
                  LabelAndTextFieldRow(
                    label: "Additional 3D revision",
                    controller: revision3DController,
                    labelText: "Amount/revision",
                    hintText: "Amount/revision",
                    keyboardType: TextInputType.number,
                  ),
                  PickHeightAndWidth.height20,
                  Text("Schedule of payment".toUpperCase(),
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Premium",
                          style: CommonTextStyle()
                              .offerLetterTopicNameTextStyle
                              .copyWith(
                                decoration: TextDecoration.none,
                              )),
                      Text(
                        "Total: ${premiumTotal.toStringAsFixed(2)}%",
                        style: CommonTextStyle()
                            .fillableTextFieldTextStyle
                            .copyWith(
                              fontSize: SizeConfig.fontSize12,
                            ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: aPremiumController,
                          labelText: "Stage 01",
                          hintText: 'Stage 01',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: bPremiumController,
                          labelText: "Stage 02",
                          hintText: 'Stage 02',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: cPremiumController,
                          labelText: "Stage 03",
                          hintText: 'Stage 03',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: dPremiumController,
                          labelText: "Stage 04",
                          hintText: 'Stage 04',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: ePremiumController,
                          labelText: "Stage 05",
                          hintText: 'Stage 05',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: fPremiumController,
                          labelText: "Stage 06",
                          hintText: 'Stage 06',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(
                                aPremiumController, () => _getPremiumTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Standard",
                          style: CommonTextStyle()
                              .offerLetterTopicNameTextStyle
                              .copyWith(
                                decoration: TextDecoration.none,
                              )),
                      Text(
                        "Total: ${standardTotal.toStringAsFixed(2)}%",
                        style: CommonTextStyle()
                            .fillableTextFieldTextStyle
                            .copyWith(
                              fontSize: SizeConfig.fontSize12,
                            ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: aStandardPremiumController,
                          labelText: "Stage 01",
                          hintText: 'Stage 01',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(aStandardPremiumController,
                                () => _getStandardTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: bStandardPremiumController,
                          labelText: "Stage 02",
                          hintText: 'Stage 02',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(bStandardPremiumController,
                                () => _getStandardTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Flexible(
                        child: CommonTextFieldWithFocus(
                          controller: cStandardPremiumController,
                          labelText: "Stage 03",
                          hintText: 'Stage 03',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            limitInputBasedOnTotal(cStandardPremiumController,
                                () => _getStandardTotal()),
                          ],
                          labelTextStyle: CommonTextStyle()
                              .fillableTextFieldTextStyle
                              .copyWith(fontSize: SizeConfig.fontSize12),
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height20,
                  Text("SCOPE DESCRIBED BY CLIENT",
                      style: CommonTextStyle().offerLetterTopicNameTextStyle),
                  PickHeightAndWidth.height10,
                  CommonTextFieldWithFocus(
                    controller: clientRequirementsController,
                    labelText: "Client requirements",
                    hintText: "Client requirements",
                    maxLines: 2,
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height20,
                  CommonMaterialButton(
                    title: 'Create PDF',
                    style: CommonTextStyle().buttonTextStyle,
                    onPressed: _generatePDF,
                    color: PickColors.primaryColor,
                    verticalPadding: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
