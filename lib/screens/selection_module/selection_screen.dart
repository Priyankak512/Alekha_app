import 'dart:io';
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
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? _selectedProjectType;

  File? _image;
  List<File> _images = [];

  TextEditingController clientNameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController selectionTimeController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();

  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  TextEditingController description3Controller = TextEditingController();
  TextEditingController description4Controller = TextEditingController();
  TextEditingController description5Controller = TextEditingController();
  TextEditingController description6Controller = TextEditingController();
  TextEditingController description7Controller = TextEditingController();
  TextEditingController description8Controller = TextEditingController();

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
        "${projectNumberController.text} ${_selectedProjectType == 'Architecture - A' ? 'A' : _selectedProjectType == 'Interior - I' ? 'I' : _selectedProjectType == 'Architecture Interior - AI' ? 'AI' : ''}";
// Helper function to build a row of text fields
    pw.Widget _buildTextFieldRow(String label, String value, pw.Document pdf) {
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
                  fontSize: 13, // Adjust font size for label
                ),
              ),
              pw.Text(
                value,
                style: const pw.TextStyle(
                  fontSize: 13, // Adjust font size for value
                ),
              ),
            ],
          ),
        );
      } else {
        return pw.SizedBox(); // Return an empty SizedBox if value is empty
      }
    }

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
              // pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [
              //       pw.Container(
              //         width: 170, // Adjust the width as needed
              //         height: 60, // Adjust the height as needed
              //         decoration: pw.BoxDecoration(
              //           image: pw.DecorationImage(
              //               image: pw.MemoryImage(imageData),
              //               // Load image from memory
              //               fit: pw.BoxFit.fill),
              //         ),
              //       ),
              //       pw.Column(
              //         crossAxisAlignment: pw.CrossAxisAlignment.start,
              //         children: [
              //           pw.Text(
              //             "Ar. Ronak Surendra Jain",
              //             style: pw.TextStyle(
              //                 fontSize: 10,
              //                 fontWeight: pw.FontWeight.normal,
              //                 color: PdfColor.fromHex("#424242")),
              //           ),
              //           pw.Text(
              //             "93760 73577",
              //             style: pw.TextStyle(
              //                 fontSize: 10,
              //                 fontWeight: pw.FontWeight.normal,
              //                 color: PdfColor.fromHex("#424242")),
              //           ),
              //           pw.SizedBox(height: 15),
              //           pw.Text(
              //             "Ar. Tushar N. Kachhadiya",
              //             style: pw.TextStyle(
              //                 fontSize: 10,
              //                 fontWeight: pw.FontWeight.normal,
              //                 color: PdfColor.fromHex("#424242")),
              //           ),
              //           pw.Text(
              //             "87588 23271",
              //             style: pw.TextStyle(
              //                 fontSize: 10,
              //                 fontWeight: pw.FontWeight.normal,
              //                 color: PdfColor.fromHex("#424242")),
              //           ),
              //         ],
              //       ),
              //     ]),
              pw.SizedBox(height: 6),
              // pw.Divider(color: PdfColor.fromHex("#616161"), height: 5),
              pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Selection",
                    style: pw.TextStyle(
                        fontSize: 13, fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.normal,
                        color: PdfColor.fromHex("#616161")),
                  ),
                ],
              ),
              pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
              pw.SizedBox(height: 5),

              _buildTextFieldRow(
                  'Client Name : ', clientNameController.text, pdf),

              _buildTextFieldRow('Project No. : ', formattedProject, pdf),

              _buildTextFieldRow(
                  'Selection Time :', selectionTimeController.text, pdf),
            ],
          );
        },
      ),
    );

    for (var imageFile in _images) {
      final image = pw.MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(20),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }
    // Print the PDF or show preview
    await Printing.layoutPdf(
        name:
            '${projectNumberController.text} SELECTION ${dateMeetingController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Helper function to build a row of text fields
  pw.Widget _buildTextFieldRow(String label, String value, pw.Document pdf) {
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
                fontSize: 13, // Adjust font size for label
              ),
            ),
            pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 13, // Adjust font size for value
              ),
            ),
          ],
        ),
      );
    } else {
      return pw.SizedBox(); // Return an empty SizedBox if value is empty
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
              'Selection',
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
                    hintText: "Select project type",
                    name: 'Project Type',
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
                    initialValue: _selectedProjectType,
                    onChanged: (newValue) {
                      setState(
                        () {
                          _selectedProjectType = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedProjectType");
                    },
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
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: selectionTimeController,
                    labelText: "Selection Time",
                    hintText: "Selection Time",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description1Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description2Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description3Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description4Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description5Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description6Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description7Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: description8Controller,
                          labelText: "Description",
                          hintText: "Description",
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: SvgPicture.asset(PickImages.cameraIcon),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonMaterialButton(
                      title: 'Add Image',
                      onPressed: _getImage,
                      style: CommonTextStyle().buttonTextStyle,
                      prefixIcon: PickImages.cameraIcon,
                      prefixIconColor: Colors.black,
                      color: PickColors.primaryColor),
                  const SizedBox(height: 20),
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
