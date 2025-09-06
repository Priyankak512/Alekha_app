// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class ArchitectureOfferLetterScreen extends StatefulWidget {
  const ArchitectureOfferLetterScreen({super.key});

  @override
  State<ArchitectureOfferLetterScreen> createState() =>
      _ArchitectureOfferLetterScreenState();
}

class _ArchitectureOfferLetterScreenState
    extends State<ArchitectureOfferLetterScreen> {
  String? _feeStage1;
  String? _feeStage2;
  String? _feeStage3;
  String? _feeStage4;
  String? _feeStage5;
  String? _feeStage6;
  String? _stdFeeStage1;

  String? _stdFeeStage2;

  String? _stdFeeStage3;
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
  TextEditingController noOfPremiumCategorySelectionController =
      TextEditingController();
  TextEditingController noOfAdditionalVisitController = TextEditingController();
  TextEditingController layout2DController = TextEditingController();
  TextEditingController revision2DController = TextEditingController();
  TextEditingController elevation3DController = TextEditingController();
  TextEditingController elevation3DOptionalController = TextEditingController();
  TextEditingController revision3DController = TextEditingController();
  TextEditingController revision3DOptionalController = TextEditingController();
  TextEditingController monthController = TextEditingController();
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
  TextEditingController noOfOptionsController = TextEditingController();
  TextEditingController noFRevisionController = TextEditingController();

  final ncp.FlutterContactPicker _contactPicker = ncp.FlutterContactPicker();

  List<Map<String, dynamic>> basicOptions = [];
  List<Map<String, dynamic>> standardOptions = [];
  List<Map<String, dynamic>> premiumOptions = [];

  File? _image;
  List<File> _images = [];

  String buildScopeText() {
    // always required lines
    String text = """
Charges are only as per scope/area described by client.
Charges may differ if any space is deducted/added from/to designing scope.
""";

    // check agar koi bhi controller filled hai to beech ka part add karo
    if (noOfElevationController.text.isNotEmpty ||
        noOfRenderController.text.isNotEmpty ||
        noOfPremiumCategoryController.text.isNotEmpty ||
        noOfPremiumCategorySelectionController.text.isNotEmpty ||
        noOfAdditionalVisitController.text.isNotEmpty ||
        noOfOptionsController.text.isNotEmpty ||
        noFRevisionController.text.isNotEmpty ||
        layout2DController.text.isNotEmpty ||
        revision2DController.text.isNotEmpty ||
        elevation3DOptionalController.text.isNotEmpty ||
        revision3DOptionalController.text.isNotEmpty ||
        elevation3DController.text.isNotEmpty ||
        monthController.text.isNotEmpty) {
      text += """
3D Rendering of Final 3D Designs - Includes ${noOfElevationController.text} Views/space  (only for PREMIUM category)
(additional view charges - Rs.${noOfRenderController.text}/view)
Site Visits -  Includes ${noOfPremiumCategoryController.text} Visits + ${noOfPremiumCategorySelectionController.text} Selection Visits (PREMIUM category)(additional visit charges - Rs.${noOfAdditionalVisitController.text}/visit)
2D Layout - Includes ${noOfOptionsController.text} Options & ${noFRevisionController.text} Revisions
(additional 2D Layout & Revision charges - Rs.${layout2DController.text}/layout & Rs.${revision2DController.text}/revision)
3D Design - Includes ${(elevation3DOptionalController.text.isNotEmpty ? "${elevation3DOptionalController.text} Options & " : "")}${revision3DOptionalController.text} Revisions
(additional 3D Elevation & Revision charges - Rs.${elevation3DController.text}/side & Rs.${revision3DController.text}/revision)
This quote is applicable only for ${monthController.text} month from the commencement of work on site.
""";
    }

    // always last line
    text +=
        "Structural changes are chargeable after final designs. Drawing for loan process is chargeable.";

    return text;
  }

  @override
  void initState() {
    super.initState();

    basicOptions = List<Map<String, dynamic>>.from(GlobalList.basicOptions);
    standardOptions =
        List<Map<String, dynamic>>.from(GlobalList.standardOptions);
    premiumOptions = List<Map<String, dynamic>>.from(GlobalList.premiumOptions);
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

  //Fees Lists
  final selectedBasicOptions =
      GlobalList.basicOptions.where((e) => e['isChecked'] == true).toList();
  final selectedStandardOptions =
      GlobalList.standardOptions.where((e) => e['isChecked'] == true).toList();
  final selectedPremiumOptions =
      GlobalList.premiumOptions.where((e) => e['isChecked'] == true).toList();
//Create PDF :

  Future<void> _generatePDF() async {
    final selectedBasicOptions =
        basicOptions.where((e) => e['isChecked'] == true).toList();
    final selectedStandardOptions =
        standardOptions.where((e) => e['isChecked'] == true).toList();
    final selectedPremiumOptions =
        premiumOptions.where((e) => e['isChecked'] == true).toList();

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
    Uint8List offerLetterFeesImage =
        (await rootBundle.load(PickImages.offerLetterFeesImage))
            .buffer
            .asUint8List();

    Uint8List offerLaterFooterImage =
        (await rootBundle.load(PickImages.offerLaterFooterImage))
            .buffer
            .asUint8List();
    Uint8List offerLetterFooterProfileLinkImage =
        (await rootBundle.load(PickImages.offerLetterFooterProfileLinkImage))
            .buffer
            .asUint8List();
    Uint8List a4PdfBgImage =
        (await rootBundle.load(PickImages.a4PdfBgImage)).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.FullPage(
              ignoreMargins: true, // Ignore margins for full control
              child: pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    image: pw.DecorationImage(
                      image: pw.MemoryImage(
                          a4PdfBgImage), // This will be your background
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  child: pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Column(
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
                                "Date : ${dateController.text}",
                                style: pw.TextStyle(
                                    font: regularFont,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColor.fromHex("#616161")),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                // flex: 2,
                                child: buildInlineTextFieldRow(
                                    'CLIENT : ',
                                    "${clientNameController.text}\n${contactNoController.text}",
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
                                      "Dear Sir,\nWe are pleased to submit herewith proposal cum contract mentioning detailed scope of work and commercial terms & conditions for your kind perusal & action for your upcoming project. \nWe at ",
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
                                      ", are an efficient professional Architectural & Interior Designing firm providing all Architectural, Interior Design, Structural & Civil Services under single roof, with an experienced, qualified & trained team we can assure you best of our services.",
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
                                image:
                                    pw.MemoryImage(offerLaterProcessWorkImage),
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
                              padding: const pw.EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                top: 10,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("#FFFFFF"),
                                borderRadius: pw.BorderRadius.circular(5),
                                border: pw.Border.all(
                                    color: PdfColor.fromHex("#BDBDBD"),
                                    width: 0.2),
                              ),
                              child: pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    // padding: const pw.EdgeInsets.all(5),
                                    width:
                                        120, // Adjust image width as per your design
                                    height: 120,

                                    child: pw.Image(
                                      pw.MemoryImage(offerLaterScopOfWorkImage),
                                      fit: pw.BoxFit.contain,
                                    ),
                                  ),

                                  pw.SizedBox(
                                      width:
                                          12), // Spacing between image and grid

                                  /// 🔹 RIGHT SIDE GRID CONTAINER
                                  pw.Expanded(
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: List.generate(
                                          (selectedOptions.length / 3).ceil(),
                                          (rowIndex) {
                                        final chunk = selectedOptions
                                            .skip(rowIndex * 3)
                                            .take(3)
                                            .toList();
                                        return pw.Row(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children:
                                              List.generate(3, (colIndex) {
                                            if (colIndex < chunk.length) {
                                              return pw.Expanded(
                                                child: pw.Container(
                                                    padding: const pw
                                                        .EdgeInsets.only(
                                                        left: 6,
                                                        bottom: 6,
                                                        right: 6,
                                                        top: 6),
                                                    margin: const pw
                                                        .EdgeInsets.only(
                                                        top: 4,
                                                        bottom: 4,
                                                        right: 12),
                                                    decoration:
                                                        pw.BoxDecoration(
                                                      color: PdfColor.fromHex(
                                                          "#EBECEC"),
                                                      borderRadius:
                                                          pw.BorderRadius
                                                              .circular(5),
                                                    ),
                                                    alignment:
                                                        pw.Alignment.center,
                                                    // child: pw.Text(
                                                    //   chunk[colIndex]['title'],
                                                    //   style: pw.TextStyle(
                                                    //     font: calibriBoldFont,
                                                    //     fontSize: 15,
                                                    //   ),
                                                    // ),
                                                    child: pw.FittedBox(
                                                        fit:
                                                            pw.BoxFit.scaleDown,
                                                        // alignment: pw.Alignment.centerLeft,
                                                        child: pw.Center(
                                                          child: pw.Text(
                                                            chunk[colIndex]
                                                                ['title'],
                                                            style: pw.TextStyle(
                                                              font:
                                                                  calibriBoldFont,
                                                              fontSize:
                                                                  15, // Starting font size, will scale down
                                                            ),
                                                          ),
                                                        ))),
                                              );
                                            } else {
                                              return pw.Expanded(
                                                  child: pw.Container());
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
                          // pw.Column(
                          //   crossAxisAlignment: pw.CrossAxisAlignment.stretch, // full width
                          //   children: [
                          /// Top line in full width, centered
                          // pw.Container(
                          //   width: double.infinity,
                          //   child: pw.RichText(
                          //     textAlign:
                          //         pw.TextAlign.center, // 👈 center within full width
                          //     text: pw.TextSpan(
                          //       children: [
                          //         pw.TextSpan(
                          //           text:
                          //               "Have a look on our Work Profile by clicking on : ",
                          //           style: pw.TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: pw.FontWeight.bold,
                          //             font: boldFont,
                          //           ),
                          //         ),
                          //         pw.TextSpan(
                          //           text: "âlekha architects",
                          //           style: pw.TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: pw.FontWeight.bold,
                          //             font: boldFont,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          pw.UrlLink(
                            destination:
                                "https://drive.google.com/file/d/1P_2TqdiB-DCNpGdnzNHFniVyr3EPv0J5/view?usp=sharing",
                            child: pw.Container(
                              width: double.infinity,
                              height: 15,
                              decoration: pw.BoxDecoration(
                                image: pw.DecorationImage(
                                  image: pw.MemoryImage(
                                      offerLetterFooterProfileLinkImage),
                                  fit: pw.BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),

                          // pw.SizedBox(height: 5),

                          /// Full width divider
                          pw.Divider(
                            thickness: 0.5,
                            color: PdfColors.grey600,
                          ),

                          // pw.SizedBox(height: 4),

                          /// Address text in full width, centered
                          //     pw.Container(
                          //       width: double.infinity,
                          //       child: pw.Text(
                          //         "28-29, Hiranagar, G.H.B., Bamroli Rd., Pandesara, Surat - 394221",
                          //         textAlign: pw.TextAlign.center, // 👈 centered
                          //         style: pw.TextStyle(
                          //           fontSize: 8,
                          //           letterSpacing: 1.2,
                          //           font: regularFont,
                          //           color: PdfColors.grey800,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          pw.Container(
                            width: double.infinity,
                            height: 25,
                            decoration: pw.BoxDecoration(
                              image: pw.DecorationImage(
                                image: pw.MemoryImage(offerLaterFooterImage),
                                fit: pw.BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ],
                      ))));
        },
      ),
    );

    // PREMIUM stages
    final premiumStages = _buildPaymentScheduleStages(
      calibriBoldFont,
      calibriRegularFont,
      isPremium: true,
    );

// STANDARD stages
    final standardStages = _buildPaymentScheduleStages(
      calibriBoldFont,
      calibriRegularFont,
      isPremium: false,
    );
    String labelText = "";
    if (premiumStages.isNotEmpty && standardStages.isNotEmpty) {
      labelText = "PREMIUM & STANDARD";
    } else if (premiumStages.isNotEmpty) {
      labelText = "PREMIUM";
    } else if (standardStages.isNotEmpty) {
      labelText = "STANDARD";
    }
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.FullPage(
              ignoreMargins: true, // Ignore margins for full control
              child: pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    image: pw.DecorationImage(
                      image: pw.MemoryImage(
                          a4PdfBgImage), // This will be your background
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
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
                        pw.Text(
                          "03. PROFESSIONAL FEES",
                          style: pw.TextStyle(
                            decoration: pw.TextDecoration.underline,
                            fontSize: 15,
                            font: calibriBoldFont,
                            // color: PdfColor.fromHex("#000000"),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          " We are charging professional fee in the following stages consistent with the work done plus other charges and reimbursable expenses as agreed upon :",
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.RichText(
                          text: pw.TextSpan(
                            style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 10,
                              color: PdfColor.fromHex("#010101"),
                            ),
                            children: [
                              pw.TextSpan(
                                text: "All specified ",
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.normal,
                                ),
                              ),
                              pw.TextSpan(
                                text: "Scope of Work ",
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex("#000000"),
                                ),
                              ),
                              pw.TextSpan(
                                text: "our fees charges would be as follows",
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // pw.Text("${basicOptions}"),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Container(
                          // padding: const pw.EdgeInsets.all(12),
                          // padding:pw. EdgeInsets.only(top: 10,bottom: 10,left: 10),
                          decoration: pw.BoxDecoration(
                            // color: PdfColor.fromHex("#F5F5F5"),
                            borderRadius: pw.BorderRadius.circular(8),
                            border: pw.Border.all(
                                color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                          ),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              /// 🔹 First Column - Icon + Title
                              pw.Container(
                                width: 120,
                                height: 120,
                                padding: const pw.EdgeInsets.all(8),
                                margin: pw.EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex("#ECECEC"),
                                  borderRadius: pw.BorderRadius.circular(10),
                                ),
                                child: pw.Image(
                                  pw.MemoryImage(offerLetterFeesImage),
                                ),
                              ),

                              pw.SizedBox(width: 10),

                              // Conditional Category Columns
                              if (selectedBasicOptions.isNotEmpty)
                                buildServiceColumn(
                                    "BASIC",
                                    selectedBasicOptions,
                                    calibriBoldFont,
                                    calibriRegularFont,
                                    basicFeesController.text),

                              if (selectedStandardOptions.isNotEmpty)
                                buildServiceColumn(
                                    "STANDARD",
                                    selectedStandardOptions,
                                    calibriBoldFont,
                                    calibriRegularFont,
                                    standardFeesController.text),

                              if (selectedPremiumOptions.isNotEmpty)
                                buildServiceColumn(
                                    "PREMIUM",
                                    selectedPremiumOptions,
                                    calibriBoldFont,
                                    calibriRegularFont,
                                    premiumFeesController.text),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        // pw.Container(
                        //   padding: const pw.EdgeInsets.all(12),
                        //   decoration: pw.BoxDecoration(
                        //     // color: PdfColor.fromHex("#F5F5F5"),
                        //     borderRadius: pw.BorderRadius.circular(8),
                        //     border: pw.Border.all(
                        //         color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                        //   ),
                        //   child: pw.Row(
                        //     children: [
                        //       pw.Expanded(
                        //         child: pw.Container(),
                        //       ),
                        //       pw.Expanded(
                        //         child: pw.RichText(
                        //           text: pw.TextSpan(
                        //             children: [
                        //               pw.TextSpan(
                        //                 text: basicFeesController.text,
                        //                 style: pw.TextStyle(
                        //                   font: calibriRegularFont,
                        //                   fontSize: 15,
                        //                   color: PdfColor.fromHex("#000000"),
                        //                 ),
                        //               ),
                        //               if (basicFeesController.text.isNotEmpty)
                        //                 pw.TextSpan(
                        //                   text: "+GST",
                        //                   style: pw.TextStyle(
                        //                     font: regularFont,
                        //                     fontSize: 11,
                        //                     fontWeight: pw.FontWeight.bold,
                        //                     color: PdfColor.fromHex("#000000"),
                        //                   ),
                        //                 ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       pw.Expanded(
                        //         child: pw.RichText(
                        //           text: pw.TextSpan(
                        //             children: [
                        //               pw.TextSpan(
                        //                 text: standardFeesController.text,
                        //                 style: pw.TextStyle(
                        //                   font: calibriRegularFont,
                        //                   fontSize: 15,
                        //                   color: PdfColor.fromHex("#000000"),
                        //                 ),
                        //               ),
                        //               if (standardFeesController.text.isNotEmpty)
                        //                 pw.TextSpan(
                        //                   text: "+GST",
                        //                   style: pw.TextStyle(
                        //                     font: regularFont,
                        //                     fontSize: 11,
                        //                     fontWeight: pw.FontWeight.bold,
                        //                     color: PdfColor.fromHex("#000000"),
                        //                   ),
                        //                 ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       pw.Expanded(
                        //         child: pw.RichText(
                        //           text: pw.TextSpan(
                        //             children: [
                        //               pw.TextSpan(
                        //                 text: premiumFeesController.text,
                        //                 style: pw.TextStyle(
                        //                   font: calibriRegularFont,
                        //                   fontSize: 15,
                        //                   color: PdfColor.fromHex("#000000"),
                        //                 ),
                        //               ),
                        //               if (premiumFeesController.text.isNotEmpty)
                        //                 pw.TextSpan(
                        //                   text: "+GST",
                        //                   style: pw.TextStyle(
                        //                     font: regularFont,
                        //                     fontSize: 11,
                        //                     fontWeight: pw.FontWeight.bold,
                        //                     color: PdfColor.fromHex("#000000"),
                        //                   ),
                        //                 )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        pw.SizedBox(height: 10),
//               pw.Text(
//                 """
//      Charges are only as per scope/area describe by client.
//      Charges may differ if any space is deducted/added from/to designing scope.
//      3D Rendering of Final 3D Designs - Includes ${noOfElevationController.text} Views/space  (only for PREMIUM category)
//      (additional view charges - Rs.${noOfRenderController.text}/view)
//      Site Visits -  Includes ${noOfPremiumCategoryController.text} Visits + ${noOfPremiumCategorySelectionController.text} Selection Visits (PREMIUM category)(additional visit charges - Rs.${noOfAdditionalVisitController.text}/visit)
//      2D Layout - Includes ${noOfOptionsController.text} Options & ${noFRevisionController.text} Revisions
//      (additional 2D Layout & Revision charges - Rs.${layout2DController.text}/layout & Rs.${revision2DController.text}/revision)
//      3D Design - Includes ${elevation3DOptionalController.text} Options ${revision3DOptionalController.text.isNotEmpty ? " & ${revision3DOptionalController.text} Revisions" : ""}
//      (additional 3D Elevation & Revision charges - Rs.${elevation3DController.text}/side & Rs.${revision3DController.text}/revision)
//      This quote is applicable only for ${monthController.text} month from the commencement of work on site.
//      Structural changes are chargeable after final designs. Drawing for loan process is chargeable.
// """,

//                 // "     Charges are only as per scope/area describe by client.\n     Charges may differ if any space is deducted/added from/to designing scope.\n     3D Rendering of Final 3D Designs - Includes ${noOfElevationController.text} Views/space  (only for PREMIUM category)\n     (additional view charges - Rs.${noOfRenderController.text}/view)\n     Site Visits -  Includes ${noOfPremiumCategoryController.text} Visits + ${noOfPremiumCategorySelectionController.text} Selection Visits (PREMIUM category)(additional visit charges - Rs..${noOfAdditionalVisitController.text}/visit)\n     2D Layout - Includes ${noOfOptionsController.text} Options & ${noFRevisionController.text} Revisions\n     (additional 2D Layout & Revision charges - Rs..${layout2DController.text}/layout & Rs..${revision2DController.text}/revision)\n     3D Design - Includes ${elevation3DOptionalController.text} Revisions ${revision3DOptionalController.text.isNotEmpty??"& ${revision3DOptionalController.text.isNotEmpty}Revisions"}\n     (additional 3D Elevation & Revision charges - Rs..${elevation3DController.text}/space & Rs..${revision3DController.text}/revision)\n     This quote is applicable only for ${monthController.text} month from the commencement of work on site.)\n     Structural changes are chargeable after final designs. Drawing for loan process is chargeable.",
//                 style: pw.TextStyle(
//                   font: regularFont,
//                   fontSize: 9,
//                   fontWeight: pw.FontWeight.normal,
//                 ),
//               ),
                        pw.Text(
                          buildScopeText(),
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),

                        pw.SizedBox(height: 15),
                        pw.Text(
                          "04. SCHEDULE OF PAYMENT :",
                          style: pw.TextStyle(
                            decoration: pw.TextDecoration.underline,
                            fontSize: 15,
                            font: calibriBoldFont,
                            // color: PdfColor.fromHex("#000000"),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        // pw.Text(
                        //   "We are charging professional fee in the following stages consistent with the work done plus other charges and reimbursable expenses as agreed upon : PREMIUM",
                        //   style: pw.TextStyle(
                        //     font: regularFont,
                        //     fontSize: 11,
                        //     fontWeight: pw.FontWeight.normal,
                        //   ),
                        // ),
                        // pw.SizedBox(height: 5),
                        // pw.Container(
                        //   width: double.infinity,
                        //   padding:
                        //       pw.EdgeInsets.only(right: 5, bottom: 8, left: 8, top: 8),
                        //   // padding: const pw.EdgeInsets.all(8),
                        //   decoration: pw.BoxDecoration(
                        //     borderRadius: pw.BorderRadius.circular(8),
                        //     border: pw.Border.all(
                        //         color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                        //   ),
                        //   child: pw.Wrap(
                        //     spacing: 2,
                        //     runSpacing: 2,
                        //     children: _buildPaymentScheduleStages(
                        //         calibriBoldFont, calibriRegularFont,
                        //         isPremium: true),
                        //   ),
                        // ),
                        // pw.SizedBox(height: 5),
                        // pw.Container(
                        //   width: double.infinity,
                        //   padding:
                        //       pw.EdgeInsets.only(right: 5, bottom: 8, left: 8, top: 8),
                        //   decoration: pw.BoxDecoration(
                        //     borderRadius: pw.BorderRadius.circular(8),
                        //     border: pw.Border.all(
                        //         color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                        //   ),
                        //   child: pw.Row(
                        //     children: [
                        //       pw.Text(
                        //         "Standard".toUpperCase(),
                        //         style: pw.TextStyle(
                        //           font: regularFont,
                        //           fontSize: 11,
                        //           fontWeight: pw.FontWeight.normal,
                        //         ),
                        //       ),
                        //       pw.SizedBox(width: 15),
                        //       pw.Wrap(
                        //         spacing: 2,
                        //         runSpacing: 2,
                        //         children: _buildPaymentScheduleStages(
                        //           calibriBoldFont,
                        //           calibriRegularFont,
                        //           isPremium: false,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "We are charging professional fee in the following stages consistent with the work done plus other charges and reimbursable expenses as agreed upon : ${labelText.isNotEmpty ? labelText : ""}",
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                            pw.SizedBox(height: 5),

                            // PREMIUM container only if stages exist
                            if (premiumStages.isNotEmpty)
                              pw.Container(
                                width: double.infinity,
                                padding: pw.EdgeInsets.all(8),
                                decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(8),
                                  border: pw.Border.all(
                                      color: PdfColor.fromHex("#BDBDBD"),
                                      width: 0.5),
                                ),
                                child: pw.Wrap(
                                  spacing: 2,
                                  runSpacing: 2,
                                  children: premiumStages,
                                ),
                              ),

                            pw.SizedBox(height: 5),

                            // STANDARD container only if stages exist
                            if (standardStages.isNotEmpty)
                              pw.Container(
                                width: double.infinity,
                                padding: pw.EdgeInsets.all(8),
                                decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(8),
                                  border: pw.Border.all(
                                      color: PdfColor.fromHex("#BDBDBD"),
                                      width: 0.5),
                                ),
                                child: pw.Wrap(
                                  spacing: 2,
                                  runSpacing: 2,
                                  children: standardStages,
                                ),
                              ),
                          ],
                        ),

                        pw.SizedBox(height: 15),
                        pw.Text(
                          "05. SCOPE DESCRIBED BY CLIENT : ",
                          style: pw.TextStyle(
                            decoration: pw.TextDecoration.underline,
                            fontSize: 15,
                            font: calibriBoldFont,
                            // color: PdfColor.fromHex("#000000"),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          clientRequirementsController.text.length > 300
                              ? clientRequirementsController.text
                                  .substring(0, 300)
                              : clientRequirementsController.text,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),

                        // pw.Text(
                        //   clientRequirementsController.text,
                        //   style: pw.TextStyle(
                        //     font: regularFont,
                        //     fontSize: 11,
                        //     fontWeight: pw.FontWeight.normal,
                        //   ),
                        // ),
                        pw.SizedBox(height: 15),

                        if (_images.isEmpty)
                          pw.Text(
                            "Thank You.",
                            style: pw.TextStyle(
                              decoration: pw.TextDecoration.underline,
                              fontSize: 12,
                              font: calibriBoldFont,
                            ),
                          ),
                        pw.Text(
                          "Note : Additional GST would be applicable on professional fees on all categories. | Advance payment is non refundable in any case. | Design quote is totally upon requirement/scope described by client, quote may differ as requirements/scope changes. | Quote given are subjected to change without prior information. |CAD or SKP file of final designs additional charges are applicable.",
                          style: pw.TextStyle(
                            fontSize: 7,
                            font: calibriRegularFont,
                          ),
                        ),
                        pw.Spacer(),
                        pw.Divider(
                          thickness: 0.5,
                          color: PdfColors.grey600,
                        ),
                        pw.Container(
                          width: double.infinity,
                          height: 25,
                          decoration: pw.BoxDecoration(
                            image: pw.DecorationImage(
                              image: pw.MemoryImage(offerLaterFooterImage),
                              fit: pw.BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
        },
      ),
    );

//////#rd Page
    // pdf.addPage(
    //   pw.Page(
    //     margin: const pw.EdgeInsets.all(20),
    //     build: (pw.Context context) {
    //       return pw.Column(
    //           crossAxisAlignment: pw.CrossAxisAlignment.start,
    //           children: [
    //             pw.Container(
    //               width: double.infinity,
    //               height: 100,
    //               margin: const pw.EdgeInsets.only(bottom: 2),
    //               decoration: pw.BoxDecoration(
    //                 image: pw.DecorationImage(
    //                   image: pw.MemoryImage(imageData),
    //                   fit: pw.BoxFit.fitWidth,
    //                 ),
    //               ),
    //             ),
    //             pw.SizedBox(height: 5),
    //             pw.Text(
    //               "INTERIOR DESIGNING SERVICES & DRAWINGS - PREMIUM",
    //               style: pw.TextStyle(
    //                 decoration: pw.TextDecoration.underline,
    //                 fontSize: 15,
    //                 font: calibriBoldFont,
    //                 // color: PdfColor.fromHex("#000000"),
    //               ),
    //             ),
    //             pw.SizedBox(height: 5),
    //             pw.Text(
    //               "01. Presenta on Floor Plan with Furniture layout (Conceptual)\n02. Presenta on Floor Plan (Civil Changes)*\n 03. Vastu Zoning\n04. Master Layout - Furniture & Civil Work.\n05. 3D Model Design - Each Space\n06. Civil Changes Working Drawing\n          a. Any civil changes\n,          b. Kitchen Pla orm Work\n          c. Tiling Work (Floor & Wall) \n07. False Ceiling Working\n08. Electrical layout & Schedule\n09. Wardrobe Segment & Presenta on drawing\n10. Master Bedroom/s working drawing\n",
    //               style: pw.TextStyle(
    //                 font: regularFont,
    //                 fontSize: 11,
    //                 fontWeight: pw.FontWeight.normal,
    //               ),
    //             ),
    //           ]);
    //     },
    //   ),
    // );

    for (int i = 0; i < _images.length; i += 4) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
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
                pw.Text(
                  "06. SITE PICTURES/LAYOUT",
                  style: pw.TextStyle(
                    decoration: pw.TextDecoration.underline,
                    fontSize: 15,
                    font: calibriBoldFont,
                    // color: PdfColor.fromHex("#000000"),
                  ),
                ),

                // 📌 Image Grid Full Height
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // Top Row
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            _buildImageBox(_images, i),
                            _buildImageBox(_images, i + 1),
                          ],
                        ),
                      ),
                      // Bottom Row
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            _buildImageBox(_images, i + 2),
                            _buildImageBox(_images, i + 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Text(
                  "Thank You.",
                  style: pw.TextStyle(
                    decoration: pw.TextDecoration.underline,
                    fontSize: 12,
                    font: calibriBoldFont,
                  ),
                ),
                pw.Text(
                  "Note : Additional GST would be applicable on professional fees on all categories. | Advance payment is non refundable in any case. | Design quote is totally upon requirement/scope described by client, quote may differ as requirements/scope changes. | Quote given are subjected to change without prior information. |CAD or SKP file of final designs additional charges are applicable.",
                  style: pw.TextStyle(
                    fontSize: 7,
                    font: calibriRegularFont,
                  ),
                ),
                pw.Divider(
                  thickness: 0.5,
                  color: PdfColors.grey600,
                ),
                pw.Container(
                  width: double.infinity,
                  height: 25,
                  decoration: pw.BoxDecoration(
                    image: pw.DecorationImage(
                      image: pw.MemoryImage(offerLaterFooterImage),
                      fit: pw.BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // Save and share the generated PDF
    await Printing.layoutPdf(
      name:
          'OFFER LETTER ARCHITECTURE ${clientNameController.text.toUpperCase()} ${dateController.text.replaceAll('_', '/')} ',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Helper widget for image box with border + radius
  pw.Widget _buildImageBox(List<File> images, int index) {
    if (index >= images.length) {
      return pw.SizedBox(); // agar image hi nahi hai to kuch bhi na dikhao
    }

    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey),
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.ClipRRect(
          horizontalRadius: 12,
          verticalRadius: 12,
          child: pw.Image(
            pw.MemoryImage(images[index].readAsBytesSync()),
            fit: pw.BoxFit.contain,
          ),
        ),
      ),
    );
  }
  // List<pw.Widget> _buildPaymentScheduleStages(
  //     pw.Font boldFont, pw.Font regularFont) {
  //   List<pw.Widget> stageWidgets = [];

  //   List<Map<String, String>> selectedStages = [];

  //   // Add only if controller has value and dropdown selected
  //   if (aPremiumController.text.trim().isNotEmpty && _feeStage1!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": aPremiumController.text.trim() + "%",
  //       "label": _feeStage1.toString(),
  //     });
  //   }
  //   if (bPremiumController.text.trim().isNotEmpty && _feeStage2!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": bPremiumController.text.trim() + "%",
  //       "label": _feeStage2.toString(),
  //     });
  //   }
  //   if (cPremiumController.text.trim().isNotEmpty && _feeStage3!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": cPremiumController.text.trim() + "%",
  //       "label": _feeStage3.toString(),
  //     });
  //   }
  //   if (dPremiumController.text.trim().isNotEmpty && _feeStage4!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": dPremiumController.text.trim() + "%",
  //       "label": _feeStage4.toString(),
  //     });
  //   }
  //   if (ePremiumController.text.trim().isNotEmpty && _feeStage5!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": ePremiumController.text.trim() + "%",
  //       "label": _feeStage5.toString(),
  //     });
  //   }
  //   if (fPremiumController.text.trim().isNotEmpty && _feeStage6!.isNotEmpty) {
  //     selectedStages.add({
  //       "percentage": "${fPremiumController.text.trim()}%",
  //       "label": _feeStage6.toString(),
  //     });
  //   }

  //   for (var stage in selectedStages) {
  //     stageWidgets.add(
  //       pw.Container(
  //         width: 85,
  //         margin: const pw.EdgeInsets.only(right: 3),
  //         padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 5),
  //         decoration: pw.BoxDecoration(
  //           color: PdfColor.fromHex("#ECECEC"),
  //           borderRadius: pw.BorderRadius.circular(4),
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             pw.Text(
  //               stage["percentage"]!,
  //               style: pw.TextStyle(
  //                 font: boldFont,
  //                 fontSize: 12,
  //               ),
  //             ),
  //             pw.SizedBox(height: 3),
  //             pw.FittedBox(
  //               fit: pw.BoxFit.scaleDown,
  //               alignment: pw.Alignment.centerLeft,
  //               child: pw.Text(
  //                 stage["label"]!,
  //                 textAlign: pw.TextAlign.center,
  //                 style: pw.TextStyle(
  //                   font: regularFont,
  //                   fontSize: 9,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     );
  //   }

  //   return stageWidgets;
  // }

  List<pw.Widget> _buildPaymentScheduleStages(
    pw.Font boldFont,
    pw.Font regularFont, {
    required bool isPremium,
  }) {
    List<pw.Widget> stageWidgets = [];

    List<Map<String, String>> selectedStages = [];

    if (isPremium) {
      if (aPremiumController.text.trim().isNotEmpty &&
          _feeStage1?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${aPremiumController.text.trim()}%",
          "label": _feeStage1!
        });
      }
      if (bPremiumController.text.trim().isNotEmpty &&
          _feeStage2?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${bPremiumController.text.trim()}%",
          "label": _feeStage2!
        });
      }
      if (cPremiumController.text.trim().isNotEmpty &&
          _feeStage3?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${cPremiumController.text.trim()}%",
          "label": _feeStage3!
        });
      }
      if (dPremiumController.text.trim().isNotEmpty &&
          _feeStage4?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${dPremiumController.text.trim()}%",
          "label": _feeStage4!
        });
      }
      if (ePremiumController.text.trim().isNotEmpty &&
          _feeStage5?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${ePremiumController.text.trim()}%",
          "label": _feeStage5!
        });
      }
      if (fPremiumController.text.trim().isNotEmpty &&
          _feeStage6?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${fPremiumController.text.trim()}%",
          "label": _feeStage6!
        });
      }
    } else {
      if (aStandardPremiumController.text.trim().isNotEmpty &&
          _stdFeeStage1?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${aStandardPremiumController.text.trim()}%",
          "label": _stdFeeStage1!
        });
      }
      if (bStandardPremiumController.text.trim().isNotEmpty &&
          _stdFeeStage2?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${bStandardPremiumController.text.trim()}%",
          "label": _stdFeeStage2!
        });
      }
      if (cStandardPremiumController.text.trim().isNotEmpty &&
          _stdFeeStage3?.isNotEmpty == true) {
        selectedStages.add({
          "percentage": "${cStandardPremiumController.text.trim()}%",
          "label": _stdFeeStage3!
        });
      }
    }

    for (var stage in selectedStages) {
      stageWidgets.add(
        pw.Container(
          width: 85,
          margin: const pw.EdgeInsets.only(right: 3),
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 5),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex("#ECECEC"),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                stage["percentage"]!,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  stage["label"]!,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 9,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return stageWidgets;
  }

  pw.Widget buildServiceColumn(
    String title,
    List<Map<String, dynamic>> items,
    pw.Font titleFont,
    pw.Font itemFont,
    String amount,
  ) {
    return pw.Container(
      width: 140, // fixed width to ensure consistent layout in row
      padding: const pw.EdgeInsets.only(right: 15, top: 10, bottom: 10),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#ECECEC"),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(font: titleFont, fontSize: 14),
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value['title'] ?? '';
                return pw.Text(
                  "${String.fromCharCode(65 + index)}. ${text.toString().toUpperCase()}",
                  style: pw.TextStyle(
                    font: itemFont,
                    fontSize: 12,
                    color: PdfColor.fromHex("#424242"),
                  ),
                );
              }).toList(),
            ],
          ),
          if (amount.trim().isNotEmpty)
            pw.Align(
              child: pw.Container(
                width: double.infinity,
                margin: pw.EdgeInsets.only(top: 8),
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#ECECEC"),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    "$amount + GST",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
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

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          _images.add(File(pickedFile.path));
        } else {
          debugPrint("No Image selected");
        }
      },
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () => helper.onWillPop(context),
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
                'Architecture Offer Letter',
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
                    Text(
                        "Scope of Work - Architecture & Interior".toUpperCase(),
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
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
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
                      spacing: 10.0,
                      runSpacing: -8.0,
                      children: basicOptions.map((option) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          child: CheckboxListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              option['title'],
                              style: CommonTextStyle()
                                  .fillableTextFieldTextStyle
                                  .copyWith(fontSize: SizeConfig.fontSize12),
                            ),
                            value: option['isChecked'],
                            onChanged: (val) {
                              setState(() {
                                option['isChecked'] = val!;
                              });
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
                      spacing: 10.0,
                      runSpacing: -8.0,
                      children: standardOptions.map((option) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          child: CheckboxListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              option['title'],
                              style: CommonTextStyle()
                                  .fillableTextFieldTextStyle
                                  .copyWith(fontSize: SizeConfig.fontSize12),
                            ),
                            value: option['isChecked'],
                            onChanged: (val) {
                              setState(() {
                                option['isChecked'] = val!;
                              });
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
                      spacing: 10.0,
                      runSpacing: -8.0,
                      children: premiumOptions.map((option) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          child: CheckboxListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              option['title'],
                              style: CommonTextStyle()
                                  .fillableTextFieldTextStyle
                                  .copyWith(fontSize: SizeConfig.fontSize12),
                            ),
                            value: option['isChecked'],
                            onChanged: (val) {
                              setState(() {
                                option['isChecked'] = val!;
                              });
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
                      labelText: "Charges/view",
                      hintText: "Charges/view",
                      keyboardType: TextInputType.number,
                    ),
                    PickHeightAndWidth.height20,
                    Text("Site & Selection Visits",
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
                      label: "Premium Category Selection",
                      controller: noOfPremiumCategorySelectionController,
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
                      label: "2D layout options",
                      controller: noOfOptionsController,
                      labelText: "No. of options",
                      hintText: "No. of options",
                      keyboardType: TextInputType.number,
                    ),
                    PickHeightAndWidth.height10,
                    LabelAndTextFieldRow(
                      label: "2D layout revision",
                      controller: noFRevisionController,
                      labelText: "No. of revision",
                      hintText: "No. of revision",
                      keyboardType: TextInputType.number,
                    ),
                    PickHeightAndWidth.height10,
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
                      label: "3D elevation options",
                      controller: elevation3DOptionalController,
                      labelText: "No. of options",
                      hintText: "No. of options",
                      keyboardType: TextInputType.number,
                    ),
                    PickHeightAndWidth.height10,
                    LabelAndTextFieldRow(
                      label: "3D elevation revision",
                      controller: revision3DOptionalController,
                      labelText: "No. of revision",
                      hintText: "No. of revision",
                      keyboardType: TextInputType.number,
                    ),
                    PickHeightAndWidth.height20,
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
                    LabelAndTextFieldRow(
                      label: "Quote Applicable Until",
                      controller: monthController,
                      labelText: "No. Of Months",
                      hintText: "No. Of Months",
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
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: aPremiumController,
                            labelText: "Stage 01 %",
                            hintText: 'Stage 01 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage1,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage1 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: bPremiumController,
                            labelText: "Stage 02 %",
                            hintText: 'Stage 02 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage2,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage2 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: cPremiumController,
                            labelText: "Stage 03 %",
                            hintText: 'Stage 03 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage3,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage3 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: dPremiumController,
                            labelText: "Stage 04 %",
                            hintText: 'Stage 04 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage4,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage4 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: ePremiumController,
                            labelText: "Stage 05 %",
                            hintText: 'Stage 05 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage5,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage5 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: fPremiumController,
                            labelText: "Stage 06 %",
                            hintText: 'Stage 06 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.feesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _feeStage6,
                            onChanged: (newValue) {
                              setState(() {
                                _feeStage6 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: aPremiumController,
                    //         labelText: "Stage 01",
                    //         hintText: 'Stage 01',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //     PickHeightAndWidth.width5,
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: bPremiumController,
                    //         labelText: "Stage 02",
                    //         hintText: 'Stage 02',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //     PickHeightAndWidth.width5,
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: cPremiumController,
                    //         labelText: "Stage 03",
                    //         hintText: 'Stage 03',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // PickHeightAndWidth.height10,
                    // Row(
                    //   children: [
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: dPremiumController,
                    //         labelText: "Stage 04",
                    //         hintText: 'Stage 04',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //     PickHeightAndWidth.width5,
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: ePremiumController,
                    //         labelText: "Stage 05",
                    //         hintText: 'Stage 05',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //     PickHeightAndWidth.width5,
                    //     Flexible(
                    //       child: CommonTextFieldWithFocus(
                    //         controller: fPremiumController,
                    //         labelText: "Stage 06",
                    //         hintText: 'Stage 06',
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'^\d+\.?\d{0,2}')),
                    //           limitInputBasedOnTotal(
                    //               aPremiumController, () => _getPremiumTotal()),
                    //         ],
                    //         labelTextStyle: CommonTextStyle()
                    //             .fillableTextFieldTextStyle
                    //             .copyWith(fontSize: SizeConfig.fontSize12),
                    //       ),
                    //     ),
                    //   ],
                    // ),

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
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: aStandardPremiumController,
                            labelText: "Stage 01 %",
                            hintText: 'Stage 01 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.standardFeesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _stdFeeStage1,
                            onChanged: (newValue) {
                              setState(() {
                                _stdFeeStage1 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: bStandardPremiumController,
                            labelText: "Stage 02 %",
                            hintText: 'Stage 02 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.standardFeesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _stdFeeStage2,
                            onChanged: (newValue) {
                              setState(() {
                                _stdFeeStage2 = newValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,

                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: cStandardPremiumController,
                            labelText: "Stage 03 %",
                            hintText: 'Stage 03 %',
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
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: CommonDropDownWithoutSearch(
                            borderColor: PickColors.primaryColor,
                            hintText: "Stage",
                            name: 'Stage',
                            items: GlobalList.standardFeesStage
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow: TextOverflow
                                            .ellipsis, // to avoid internal overflow
                                        style: CommonTextStyle()
                                            .textFieldTitleTextStyle,
                                      ),
                                    ))
                                .toList(),
                            isExpanded: true, // <- very important
                            initialValue: _stdFeeStage3,
                            onChanged: (newValue) {
                              setState(() {
                                _stdFeeStage3 = newValue.toString();
                              });
                            },
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
                    _images.isNotEmpty
                        ? SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      margin: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        _images[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Container(),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CommonMaterialButton(
                            title: "Add Pictures",
                            suffixIcon: PickImages.cameraIcon,
                            style: CommonTextStyle().buttonTextStyle,
                            verticalPadding: 20,
                            color: PickColors.primaryColor,
                            onPressed: () {
                              _getImage();
                            },
                          ),
                        ),
                        PickHeightAndWidth.width10,
                        Expanded(
                          child: CommonMaterialButton(
                         title: "Export As Pdf",
                            suffixIcon: PickImages.pdfIcon,
                            style: CommonTextStyle().buttonTextStyle,
                            onPressed: _generatePDF,
                            color: PickColors.primaryColor,
                            verticalPadding: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
