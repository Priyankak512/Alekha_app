import 'dart:io';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_image_picker.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  TextEditingController addressController = TextEditingController();
  TextEditingController selectionVisitNumber = TextEditingController();

  TextEditingController description1Controller = TextEditingController();
  File? image1;
  TextEditingController description2Controller = TextEditingController();
  File? image2;
  TextEditingController description3Controller = TextEditingController();
  File? image3;
  TextEditingController description4Controller = TextEditingController();
  File? image4;
  TextEditingController description5Controller = TextEditingController();
  File? image5;
  TextEditingController description6Controller = TextEditingController();
  File? image6;
  TextEditingController description7Controller = TextEditingController();
  File? image7;
  TextEditingController description8Controller = TextEditingController();
  File? image8;

  Future<void> _generatePDF() async {
    Uint8List a4PdfBgImage =
        (await rootBundle.load(PickImages.a4PdfBgImage)).buffer.asUint8List();
    final pdf = pw.Document();

    Uint8List imageData =
        (await rootBundle.load(PickImages.alekhaArchitectsIcon))
            .buffer
            .asUint8List();
    Uint8List invoiceContactPdfLogo =
        (await rootBundle.load(PickImages.siteVisitContactsPdfImage))
            .buffer
            .asUint8List();

    Uint8List offerLetterFooterProfileLinkImage =
        (await rootBundle.load(PickImages.offerLetterFooterProfileLinkImage))
            .buffer
            .asUint8List();

    Uint8List offerLaterFooterImage =
        (await rootBundle.load(PickImages.offerLaterFooterImage))
            .buffer
            .asUint8List();

    // Project No formatting
    String formattedProject =
        "${projectNumberController.text} ${_selectedProjectType == 'Architecture - A' ? 'A' : _selectedProjectType == 'Interior - I' ? 'I' : _selectedProjectType == 'Architecture Interior - AI' ? 'AI' : ''}";

    // Descriptions list
    final descriptions = [
      description1Controller.text,
      description2Controller.text,
      description3Controller.text,
      description4Controller.text,
      description5Controller.text,
      description6Controller.text,
      description7Controller.text,
      description8Controller.text,
    ];

// --- Full Header (Page 1 only)
    pw.Widget _buildFullHeader() {
      return pw.Column(
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
              pw.Container(
                width: 120,
                height: 60,
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(invoiceContactPdfLogo),
                    fit: pw.BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "SELECTION",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "${DateFormat('dd/MM/yyyy').format(DateTime.now())} ${selectionTimeController.text.isNotEmpty ? ' - ${selectionTimeController.text}' : ''}",
                style: pw.TextStyle(
                    fontSize: 13,
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
                  'Selection Visit No. : ',
                  selectionVisitNumber.text,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
        ],
      );
    }

// --- Short Header (Page 2+)
    pw.Widget _buildShortHeader() {
      return pw.Column(
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
              pw.Container(
                width: 120,
                height: 60,
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(invoiceContactPdfLogo),
                    fit: pw.BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "SELECTION",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "${DateFormat('dd/MM/yyyy').format(DateTime.now())} ${selectionTimeController.text.isNotEmpty ? ' - ${selectionTimeController.text}' : ''}",

                // "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
                style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColor.fromHex("#616161")),
              ),
            ],
          ),
          pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
          pw.SizedBox(height: 10),
        ],
      );
    }

    // --- Image + Description (single box)

    pw.Widget _buildImageWithDescription(int index) {
      if (index >= _images.length && index >= descriptions.length) {
        return pw.SizedBox();
      }

      final File? imageFile = index < _images.length ? _images[index] : null;
      final String description =
          index < descriptions.length ? descriptions[index] : "";

      return pw.Expanded(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center, // ✅ center align
          children: [
            if (imageFile != null)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 15),
                alignment: pw.Alignment.center,
                child: pw.ClipRRect(
                  horizontalRadius: 12,
                  verticalRadius: 12,
                  child: pw.Image(
                    pw.MemoryImage(imageFile.readAsBytesSync()),
                    fit: pw.BoxFit.contain,
                    height: 240,
                  ),
                ),
              ),
            if (description.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.symmetric(horizontal: 15),
                child: pw.Text(
                  description,
                  maxLines: 8,
                  // overflow: pw.TextOverflow.ellips,
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ]
          ],
        ),
      );
    }

    // ✅ केवल non-empty descriptions count करो
    final nonEmptyDescriptions =
        descriptions.where((d) => d.trim().isNotEmpty).toList();

// ✅ total items = max(images, nonEmptyDescriptions)
    int totalItems = _images.length > nonEmptyDescriptions.length
        ? _images.length
        : nonEmptyDescriptions.length;

// ✅ कितने total pages चाहिए (हर page पर max 4 items)
    int totalPages = (totalItems / 4).ceil();
    // for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
    //   pdf.addPage(
    //     pw.Page(
    //       margin: const pw.EdgeInsets.all(20),
    //       pageFormat: PdfPageFormat.a4,
    //       build: (pw.Context context) {
    //         return pw.Column(
    //           crossAxisAlignment: pw.CrossAxisAlignment.start,
    //           children: [
    //             // ✅ पहले पेज पर full header, बाकी पर short header
    //             pageIndex == 0 ? _buildFullHeader() : _buildShortHeader(),
    //             pw.Expanded(
    //               child: pw.Column(
    //                 children: [
    //                   pw.Expanded(
    //                     child: pw.Row(
    //                       children: [
    //                         _buildImageWithDescription(pageIndex * 4),
    //                         _buildImageWithDescription(pageIndex * 4 + 1),
    //                       ],
    //                     ),
    //                   ),
    //                   pw.Expanded(
    //                     child: pw.Row(
    //                       children: [
    //                         _buildImageWithDescription(pageIndex * 4 + 2),
    //                         _buildImageWithDescription(pageIndex * 4 + 3),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //             /// Full width divider
    //             pw.Divider(
    //               thickness: 0.5,
    //               color: PdfColors.grey600,
    //             ),
    //             pw.Container(
    //               width: double.infinity,
    //               height: 18,
    //               decoration: pw.BoxDecoration(
    //                 image: pw.DecorationImage(
    //                   image: pw.MemoryImage(offerLaterFooterImage),
    //                   fit: pw.BoxFit.fitWidth,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     ),
    //   );
    // }

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero, // ❗ important
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(a4PdfBgImage), // ✅ BG IMAGE
                    fit: pw.BoxFit.contain, // or cover
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // ✅ First page = full header, others = short header
                      pageIndex == 0 ? _buildFullHeader() : _buildShortHeader(),

                      pw.Expanded(
                        child: pw.Column(
                          children: [
                            pw.Expanded(
                              child: pw.Row(
                                children: [
                                  _buildImageWithDescription(pageIndex * 4),
                                  _buildImageWithDescription(pageIndex * 4 + 1),
                                ],
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Row(
                                children: [
                                  _buildImageWithDescription(pageIndex * 4 + 2),
                                  _buildImageWithDescription(pageIndex * 4 + 3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      pw.Divider(
                        thickness: 0.5,
                        color: PdfColors.grey600,
                      ),

                      pw.Container(
                        width: double.infinity,
                        height: 18,
                        decoration: pw.BoxDecoration(
                          image: pw.DecorationImage(
                            image: pw.MemoryImage(offerLaterFooterImage),
                            fit: pw.BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    // Print the PDF
    await Printing.layoutPdf(
      name:
          '${projectNumberController.text} SELECTION ${dateMeetingController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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

  bool _validateAndGeneratePDF() {
    final pairs = [
      [description1Controller.text, image1],
      [description2Controller.text, image2],
      [description3Controller.text, image3],
      [description4Controller.text, image4],
      [description5Controller.text, image5],
      [description6Controller.text, image6],
      [description7Controller.text, image7],
      [description8Controller.text, image8],
    ];

    for (int i = 0; i < pairs.length; i++) {
      String desc = pairs[i][0] as String;
      File? img = pairs[i][1] as File?;

      // ✅ सिर्फ उसी pair को check करेंगे जिसमें user ने कुछ डाला है
      if (desc.isNotEmpty || img != null) {
        if (desc.isNotEmpty && img == null) {
          _showError("Please select image for description.");
          return false;
        } else if (desc.isEmpty && img != null) {
          _showError("Please enter description for image.");
          return false;
        }
      }
    }

    return true; // ✅ सब ठीक है
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
                    controller: selectionVisitNumber,
                    labelText: "Selection Visit No.",
                    hintText: "Selection Visit No.",
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
                  CommonTimePickerField(
                    controller: selectionTimeController,
                    hintText: 'Selection Time',
                    labelText: 'Selection Time',
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image1",
                          onFileChange: (value) {
                            setState(() {
                              if (image1 != null) _images.remove(image1);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image1 = File(value.last.path);
                                _images.add(image1!);
                              } else {
                                image1 = null;
                              }
                            });
                          },
                        ),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image2",
                          onFileChange: (value) {
                            setState(() {
                              if (image2 != null) _images.remove(image2);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image2 = File(value.last.path);
                                _images.add(image2!);
                              } else {
                                image2 = null;
                              }
                            });
                          },
                        ),

                        // SvgPicture.asset(PickImages.cameraIcon),
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
                          maxLines: 3,
                          hintText: "Description",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            // Agar user cancel karega to value null ya empty hogi
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last.path.isNotEmpty) {
                              File selectedImage = File(value.last.path);
                              setState(() {
                                image3 = selectedImage; // ✅ validation के लिए
                                _images.add(selectedImage);
                                // image1 = File(value.last.path); // ✅ pair 1
                              });
                            }
                          },
                        ),

                        // child: SvgPicture.asset(PickImages.cameraIcon),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image4",
                          onFileChange: (value) {
                            setState(() {
                              if (image4 != null) _images.remove(image4);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image4 = File(value.last.path);
                                _images.add(image4!);
                              } else {
                                image4 = null;
                              }
                            });
                          },
                        ),

                        // child: SvgPicture.asset(PickImages.cameraIcon),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image5",
                          onFileChange: (value) {
                            setState(() {
                              if (image5 != null) _images.remove(image5);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image5 = File(value.last.path);
                                _images.add(image5!);
                              } else {
                                image5 = null;
                              }
                            });
                          },
                        ),

                        // child: SvgPicture.asset(PickImages.cameraIcon),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image6",
                          onFileChange: (value) {
                            setState(() {
                              if (image6 != null) _images.remove(image6);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image6 = File(value.last.path);
                                _images.add(image6!);
                              } else {
                                image6 = null;
                              }
                            });
                          },
                        ),

                        // child: SvgPicture.asset(PickImages.cameraIcon),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "image7",
                          onFileChange: (value) {
                            setState(() {
                              if (image7 != null) _images.remove(image7);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image7 = File(value.last.path);
                                _images.add(image7!);
                              } else {
                                image7 = null;
                              }
                            });
                          },
                        ),
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
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                150), // ✅ 150 letters तक
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        height: 100, width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        // child: ImagePickerControl(
                        //   fieldName: "",
                        //   onFileChange: (value) {
                        //     if (value != null &&
                        //         value.isNotEmpty &&
                        //         value.last != null) {
                        //       setState(() {
                        //         _images.add(File(value.last.path));
                        //       });
                        //     }
                        //   },
                        // ),
                        // child: ImagePickerControl(
                        //   fieldName: "",
                        //   onFileChange: (value) {
                        //     // Agar user cancel karega to value null ya empty hogi
                        //     if (value != null &&
                        //         value.isNotEmpty &&
                        //         value.last.path.isNotEmpty) {
                        //       setState(() {
                        //         // _images.add(File(value.last.path));

                        //         image8 = File(value.last.path);
                        //       });
                        //     }
                        //   },
                        // ),
                        child: ImagePickerControl(
                          fieldName: "image8",
                          onFileChange: (value) {
                            setState(() {
                              if (image8 != null) _images.remove(image8);
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.last.path.isNotEmpty) {
                                image8 = File(value.last.path);
                                _images.add(image8!);
                              } else {
                                image8 = null;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),  
                  
                  Row(
                    children: [
                      Expanded(
                        child: CommonMaterialButton(
                            title: 'Add Image',
                            onPressed: _getImage,
                            style: CommonTextStyle().buttonTextStyle,
                            prefixIcon: PickImages.cameraIcon,
                            prefixIconColor: Colors.black,
                            color: PickColors.primaryColor),
                      ),
                      PickHeightAndWidth.width10,
                      Expanded(
                        child: CommonMaterialButton(
                          title: "Export As Pdf",
                          prefixIcon: PickImages.pdfIcon,
                          style: CommonTextStyle().buttonTextStyle,
                          onPressed: () async {
                            if (_validateAndGeneratePDF()) {
                              await _generatePDF(); // ✅ सिर्फ तभी call होगा जब सब valid हो
                            }
                          },
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
      );
    });
  }
}
