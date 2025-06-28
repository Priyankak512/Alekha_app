import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:alekha/widget/html_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class SiteVisitReportScreen extends StatefulWidget {
  const SiteVisitReportScreen({Key? key}) : super(key: key);

  @override
  State<SiteVisitReportScreen> createState() => _CreatePdfFromDataState();
}

class _CreatePdfFromDataState extends State<SiteVisitReportScreen> {
  String? _selectedProjectCategory;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController siteVisitNumber = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController workStageOnSiteController = TextEditingController();
  // HtmlEditorController workStageOnSiteController = HtmlEditorController();
  TextEditingController decisionController = TextEditingController();
  TextEditingController decisionPendingController = TextEditingController();
  TextEditingController changesOnSiteController = TextEditingController();
  TextEditingController nextOnSiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
   TextEditingController dummy1Controller = TextEditingController();
   TextEditingController dummy2Controller = TextEditingController();

  File? _image;
  List<File> _images = [];

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    Uint8List imageData =
        (await rootBundle.load(PickImages.alekhaArchitectsIcon))
            .buffer
            .asUint8List();
    Uint8List invoiceContactPdfLogo =
        (await rootBundle.load(PickImages.siteVisitContactsPdfImage))
            .buffer
            .asUint8List();

    // Concatenate selected project category and project number
    String formattedProject =
        "${projectNumberController.text} ${_selectedProjectCategory == 'Architecture - A' ? 'A' : _selectedProjectCategory == 'Interior - I' ? 'I' : _selectedProjectCategory == 'Architecture Interior - AI' ? 'AI' : ''}";

    // Add pages to the PDF document
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 170,
                    height: 60,
                    margin: const pw.EdgeInsets.only(bottom: 2),
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image: pw.MemoryImage(imageData),
                        fit: pw.BoxFit.fill,
                      ),
                    ),
                  ),
                  // pw.Expanded(
                  //   child:
                  pw.Container(
                    width: 120,
                    height: 60,
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image: pw.MemoryImage(invoiceContactPdfLogo),
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    // ),
                  )
                ],
              ),
              pw.SizedBox(height: 6),
              // pw.Divider(color: PdfColor.fromHex("#616161"), height: 5),
              pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "SITE VISIT",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    dateController.text,
                    style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.normal,
                        color: PdfColor.fromHex("#616161")),
                  ),
                ],
              ),
              pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
              pw.SizedBox(height: 5),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: buildInlineTextFieldRow(
                      'Client Name : ',
                      clientNameController.text,
                    ),
                  ),
                  pw.Expanded(
                    child: buildInlineTextFieldRow(
                      'Project No. : ',
                      formattedProject,
                    ),
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
                      'Address : ',
                      addressController.text,
                    ),
                  ),
                  pw.Expanded(
                    child: buildInlineTextFieldRow(
                      'Site Visit No. : ',
                      siteVisitNumber.text,
                    ),
                  ),
                ],
              ),

              // Work Stage On Site
              buildMultilineField(
                  label: "Work Stage On Site :",
                  value: workStageOnSiteController.text),

              // Decision
              buildMultilineField(
                label: 'Decision :',
                value: decisionController.text,
              ),

              // Changes On Site
              buildMultilineField(
                label: 'Decision Pending :',
                value: decisionPendingController.text,
              ),

              // Decision Pending
              buildMultilineField(
                label: 'Changes On Site : ',
                value: changesOnSiteController.text,
              ),

              // Next On Site
              buildMultilineField(
                label: 'Next On Site : ',
                value: nextOnSiteController.text,
              ),
              pw.Spacer(),
              pw.Divider(color: PdfColor.fromHex("#616161")),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "G.F. Plot No.29, Hira Nagar, Bamroll Road, Nr.Saraswati Hindi Vidyalaya, Surat, Gujarat.",
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );

    // for (var imageFile in _images) {
    //   final image = pw.MemoryImage(imageFile.readAsBytesSync());
    //   pdf.addPage(
    //     pw.Page(
    //       margin: const pw.EdgeInsets.all(20),
    //       pageFormat: PdfPageFormat.a4,
    //       build: (pw.Context context) {
    //         return pw.Center(child: pw.Image(image));
    //       },
    //     ),
    //   );
    // }
    // Add images 4 per page in 2x2 grid
    for (int i = 0; i < _images.length; i += 4) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20), // optional: page margin
          build: (pw.Context context) {
            return pw.Column(
              children: [
                // Top Row
                pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Image(
                          pw.MemoryImage(_images[i].readAsBytesSync()),
                          // fit: pw.BoxFit.cover,
                        ),
                      ),
                      if (i + 1 < _images.length) ...[
                        pw.SizedBox(width: 20), // space between top images
                        pw.Expanded(
                          child: pw.Image(
                            pw.MemoryImage(_images[i + 1].readAsBytesSync()),
                            // fit: pw.BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(height: 20), // space between rows
                // Bottom Row
                pw.Expanded(
                  child: pw.Row(
                    children: [
                      if (i + 2 < _images.length)
                        pw.Expanded(
                          child: pw.Image(
                            pw.MemoryImage(_images[i + 2].readAsBytesSync()),
                            // fit: pw.BoxFit.cover,
                          ),
                        ),
                      if (i + 3 < _images.length) ...[
                        pw.SizedBox(width: 20), // space between bottom images
                        pw.Expanded(
                          child: pw.Image(
                            pw.MemoryImage(_images[i + 3].readAsBytesSync()),
                            // fit: pw.BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // Print the PDF or show preview
    await Printing.layoutPdf(
        name:
            '${projectNumberController.text} SITE VISIT ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
        onLayout: (PdfPageFormat format) async => pdf.save());
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
              'Site Visit',
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
                    controller: clientNameController,
                    labelText: "Client Name",
                    hintText: "Client Name",
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
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: addressController,
                    labelText: "Address",
                    hintText: "Address",
                    // keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: siteVisitNumber,
                    labelText: "Site Visit No.",
                    hintText: "Site Visit No.",
                    keyboardType: TextInputType.number,
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
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: workStageOnSiteController,
                    labelText: "Work Stage on Site",
                    hintText: "Work Stage on Site",
                    maxLines: 4,
                  ),
                  CommonTextFieldWitNumbers(
                    controller: dummy1Controller,
                    hintText: 'Points with Number',
                    maxLines: 5,
                    labelText: 'Points with Number',
                  ),
                   CommonTextFieldWithBullets(
                    controller: dummy2Controller,
                    hintText: 'Bullet Points',
                    maxLines: 5,
                    labelText: 'Bullet Points',
                  ),
                  // HtmlEditorWidget(
                  //     jdDescriptionController: workStageOnSiteController,
                  //     initialText: "Initial Text",
                  //     onValueChanged: (value) async {
                  //       String? html = await workStageOnSiteController.getText();
                  //       String plainText =
                  //           Bidi.stripHtmlIfNeeded(html ?? "").trim();
                  //       print("Plain Text: $plainText");
                  //     }),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: decisionController,
                    labelText: "Decisions",
                    hintText: "Decisions",
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: decisionPendingController,
                    labelText: "Decisions pending",
                    hintText: "Decisions pending",
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: changesOnSiteController,
                    labelText: "Changes on site",
                    hintText: "Changes on site",
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: nextOnSiteController,
                    labelText: "Next on site",
                    hintText: "Next on site",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 10),
                  // _images.isNotEmpty
                  //     ? SizedBox(
                  //         height: 400,
                  //         child: ListView.builder(
                  //           itemCount: _images.length,
                  //           itemBuilder: (context, index) {
                  //             return Container(
                  //               height: 400,
                  //               width: double.infinity,
                  //               margin: const EdgeInsets.all(8.00),
                  //               child: Image.file(
                  //                 _images[index],
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       )
                  //     : Container(),

                  _images.isNotEmpty
                      ? SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 400,
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
                          onPressed: () {
                            _getImage();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CommonMaterialButton(
                          title: "Export As Pdf",
                          suffixIcon: PickImages.pdfIcon,
                          style: CommonTextStyle().buttonTextStyle,
                          onPressed: () {
                            _generatePDF();
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  CommonMaterialButton(
                    color: PickColors.successColor,
                    title: "Share On Whatsapp",
                    suffixIcon: PickImages.whatsAppIcon,
                    onPressed: () {},
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

pw.Widget buildTwoColumnInfoRow({
  required String label1,
  required String value1,
  required String label2,
  required String value2,
  required pw.Font pdfFont,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: 2,
        child: buildInlineTextFieldRow(
          label1,
          value1,
        ),
      ),
      pw.Expanded(
        child: buildInlineTextFieldRow(label2, value2),
      ),
    ],
  );
}

// For inline short fields
pw.Widget buildInlineTextFieldRow(String label, String value) {
  if (value.isNotEmpty) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 15,
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  } else {
    return pw.SizedBox();
  }
}

pw.Widget buildMultilineField({
  required String label,
  required String value,
  double fontSize = 15,
  double spacing = 3,
  double indent = 15,
  bool showIfEmpty = false,
}) {
  if (value.isEmpty && !showIfEmpty) {
    return pw.SizedBox();
  }

  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 5),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        pw.SizedBox(height: spacing),
        pw.Container(
          margin: pw.EdgeInsets.only(left: indent),
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    ),
  );
}
