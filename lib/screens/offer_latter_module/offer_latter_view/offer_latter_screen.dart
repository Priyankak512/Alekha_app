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

  List<Map<String, dynamic>> basicOptions = [];
  List<Map<String, dynamic>> standardOptions = [];
  List<Map<String, dynamic>> premiumOptions = [];
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
                  padding: const pw.EdgeInsets.only(
                    bottom: 10,
                    left: 10,
                    top: 10,
                  ),
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
                                        padding: const pw.EdgeInsets.only(
                                            left: 20,
                                            bottom: 6,
                                            right: 6,
                                            top: 6),
                                        margin: const pw.EdgeInsets.only(
                                            top: 4, bottom: 4, right: 12),
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
              pw.Text(
                "Have a look on our Work Profile by clicking on : alekha architects",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 15,
                  font: calibriBoldFont,
                  // color: PdfColor.fromHex("#000000"),
                ),
              ),
              pw.Divider(
                color: PdfColor.fromHex("#616161"),
              ),
              pw.Text(
                "28-29, Hiranagar, G.H.B., Bamroli Rd., Pandesara, Surat - 394221",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 8,
                  font: calibriRegularFont,
                  // color: PdfColor.fromHex("#000000"),
                ),
              ),
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
                      text: "Scope of Work",
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
                padding: const pw.EdgeInsets.all(12),
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
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#ECECEC"),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Image(pw.MemoryImage(offerLetterFeesImage),
                              height: 50),
                          pw.SizedBox(height: 8),
                          pw.Text("Professional\nServices",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: calibriBoldFont,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 10),

                    // Conditional Category Columns
                    if (selectedBasicOptions.isNotEmpty)
                      buildServiceColumn("BASIC", selectedBasicOptions,
                          calibriBoldFont, calibriRegularFont),

                    if (selectedStandardOptions.isNotEmpty)
                      buildServiceColumn("STANDARD", selectedStandardOptions,
                          calibriBoldFont, calibriRegularFont),

                    if (selectedPremiumOptions.isNotEmpty)
                      buildServiceColumn("PREMIUM", selectedPremiumOptions,
                          calibriBoldFont, calibriRegularFont),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  // color: PdfColor.fromHex("#F5F5F5"),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                      color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(),
                    ),
                    pw.Expanded(
                      child: pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: basicFeesController.text,
                              style: pw.TextStyle(
                                font: calibriRegularFont,
                                fontSize: 15,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                            pw.TextSpan(
                              text: "+GST",
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: standardFeesController.text,
                              style: pw.TextStyle(
                                font: calibriRegularFont,
                                fontSize: 15,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                            pw.TextSpan(
                              text: "+GST",
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: premiumFeesController.text,
                              style: pw.TextStyle(
                                font: calibriRegularFont,
                                fontSize: 15,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                            pw.TextSpan(
                              text: "+GST",
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "     Charges are only as per your scope/area of design provided by client.\n     Charges may differ if any space is deducted/added from/to designing scope.\n     3D Rendering of Final 3D Designs - Includes 03 Views/space  (only for PREMIUM category)\n     (additional view charges - Rs.1,200/view)\n     Site Visits -  Includes 12 Visits + 03 Selection Visits (PREMIUM category)(additional visit charges - Rs.2,200/visit)\n     2D Layout - Includes 2 Options & 2 Revisions\n     (additional 2D Layout & Revision charges - Rs.6,000/layout & Rs.3,500/revision)\n     3D Design - Includes 2 Revisions\n     (additional 3D Elevation & Revision charges - Rs.14,500/space & Rs.5,500/revision)\n     This quote is applicable only for 8 month from the commencement of work on site.))",
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
              pw.Text(
                "We are charging professional fee in the following stages consistent with the work done plus other charges and reimbursable expenses as agreed upon : STANDARD & PREMIUM",
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 11,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  // color: PdfColor.fromHex("#F5F5F5"),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                      color: PdfColor.fromHex("#BDBDBD"), width: 0.5),
                ),
                child: pw.Row(
                  children: [],
                ),
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
                "Spaces : Residential Bungalow | G+1 Built-up | 48'-0' X 34'-0' | Interiors of all spaces includes : Foyer, Temple, Kitchen, Double height Living Room, Staircase, Bedrooms 01, 02, 03., Study, 2 Balconies.",
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 11,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                "Thank You.",
                style: pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                  fontSize: 12,
                  font: calibriBoldFont,
                ),
              ),
              pw.Text(
                " Note : Additional GST would be applicable on professional fees on all categories. | Advance payment is non refundable in any case. | Design quote is totally upon requirement/scope described by client, quote may differ as requirements/scope changes. | Quote given are subjected to change without prior information. |CAD or SKP file of final designs additional charges are applicable.",
                style: pw.TextStyle(
                  fontSize: 9,
                  font: calibriRegularFont,
                ),
              ),
            ],
          );
        },
      ),
    );

//////#rd Page
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
                pw.Text(
                  "INTERIOR DESIGNING SERVICES & DRAWINGS - PREMIUM",
                  style: pw.TextStyle(
                    decoration: pw.TextDecoration.underline,
                    fontSize: 15,
                    font: calibriBoldFont,
                    // color: PdfColor.fromHex("#000000"),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "01. Presenta on Floor Plan with Furniture layout (Conceptual)\n02. Presenta on Floor Plan (Civil Changes)*\n 03. Vastu Zoning\n04. Master Layout - Furniture & Civil Work.\n05. 3D Model Design - Each Space\n06. Civil Changes Working Drawing\n          a. Any civil changes\n,          b. Kitchen Pla orm Work\n          c. Tiling Work (Floor & Wall) \n07. False Ceiling Working\n08. Electrical layout & Schedule\n09. Wardrobe Segment & Presenta on drawing\n10. Master Bedroom/s working drawing\n",
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ]);
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

//Fees option

// Widget to build PDF service section
  pw.Widget buildServiceColumn(String title, List<Map<String, dynamic>> items,
      pw.Font titleFont, pw.Font itemFont) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            margin: pw.EdgeInsets.only(right: 10),
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex("#ECECEC"),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Center(
              child: pw.Text(title,
                  style: pw.TextStyle(font: titleFont, fontSize: 12)),
            ),
          ),
          pw.SizedBox(height: 5),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final text = entry.value['title'] ?? '';
            return pw.Text(
              "${String.fromCharCode(65 + index)}. $text",
              style: pw.TextStyle(
                  font: itemFont,
                  fontSize: 10,
                  color: PdfColor.fromHex("#424242")),
            );
          }).toList(),
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
                    spacing: 10.0,
                    runSpacing: -8.0,
                    children: basicOptions.map((option) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 16,
                        child: CheckboxListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
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
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
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
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
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
