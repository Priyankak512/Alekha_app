import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_image_picker.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, LengthLimitingTextInputFormatter, rootBundle;
// import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:alekha/widget/html_widget.dart';

class ArchitectureScreen extends StatefulWidget {
  const ArchitectureScreen({Key? key}) : super(key: key);

  @override
  State<ArchitectureScreen> createState() => _CreatePdfFromDataState();
}

class _CreatePdfFromDataState extends State<ArchitectureScreen> {
  String? _selectedProjectType;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController siteVisitNumber = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController plotSizeController = TextEditingController();
  TextEditingController siteContextController = TextEditingController();

  File? _image;
  List<File> _images = [];

  int _currentStep = 0;

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

    Uint8List a4PdfBgImage =
        (await rootBundle.load(PickImages.a4PdfBgImage)).buffer.asUint8List();

    // Retrieve the plain text content from the HtmlEditorWidget
    // String htmlContent = await requirementController.getText();
    // String requirementsText = Bidi.stripHtmlIfNeeded(htmlContent).trim();

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
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
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
                                    image:
                                        pw.MemoryImage(invoiceContactPdfLogo),
                                    fit: pw.BoxFit.contain,
                                  ),
                                ),
                              )
                            ],
                          ),
                          pw.SizedBox(height: 6),
                          pw.Divider(
                              height: 3, color: PdfColor.fromHex("#616161")),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Architecture Form".toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                ),
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
                          pw.Divider(
                              height: 3, color: PdfColor.fromHex("#BDBDBD")),
                          pw.SizedBox(height: 5),
                          _buildTextFieldRow(
                              'Client Name : ', clientNameController.text, pdf),
                          _buildTextFieldRow(
                              'Contact No. : ', contactNoController.text, pdf),
                          _buildTextFieldRow(
                              'Date :', dateController.text, pdf),
                          _buildTextFieldRow(
                              'Address : ', addressController.text, pdf),
                          _buildTextFieldRow('Project Type : ',
                              _selectedProjectType ?? "", pdf),
                          _buildTextFieldRow(
                              'Plot Size :', plotSizeController.text, pdf),
                          _buildTextFieldRow('Site Context : ',
                              siteContextController.text, pdf),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "Requirements:",
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                        ],
                      ))));
        },
      ),
    );

    // // Add images to the PDF
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
    for (var imageFile in _images) {
      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero, // 🔥 IMPORTANT
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(a4PdfBgImage),
                    fit: pw.BoxFit.contain, // same as your first page
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Center(
                    child: pw.Image(
                      image,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    // Save and share the generated PDF
    await Printing.layoutPdf(
      name:
          'ARCH FORM ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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

  // Future<void> _getImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   setState(
  //     () {
  //       if (pickedFile != null) {
  //         _images.add(File(pickedFile.path));
  //       } else {
  //         debugPrint("No Image selected");
  //       }
  //     },
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
  // Future<void> _getImage() async {
  //   final ImagePicker picker = ImagePicker();

  //   // ✅ Multiple images pick
  //   final List<XFile>? pickedFiles = await picker.pickMultiImage();

  //   if (pickedFiles != null && pickedFiles.isNotEmpty) {
  //     setState(() {
  //       _images.addAll(
  //         pickedFiles.map((xFile) => File(xFile.path)),
  //       );
  //     });
  //   } else {
  //     debugPrint("No Images selected");
  //   }
  // }
  
  Future<void> _getImage() async {
    final List<File> pickedImages =
        await CommonMultipleImagePicker.pickMultipleImages();

    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.addAll(pickedImages);
      });
    } else {
      debugPrint("No Images selected");
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
              'Architecture Form',
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
                  // CommonTextFieldWithFocus(
                  //   controller: contactNoController,
                  //   labelText: "Contact No.",
                  //   hintText: "Contact No.",
                  //   keyboardType: TextInputType.number,
                  // ),
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
                      LengthLimitingTextInputFormatter(13), // Max 13 digits
                      FilteringTextInputFormatter.digitsOnly, // Only digits
                    ],
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
                    controller: addressController,
                    labelText: "Address",
                    hintText: "Address",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Project Type",
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
                  CommonTextFieldWithFocus(
                    controller: plotSizeController,
                    labelText: "Plot Size",
                    hintText: "Plot Size",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // CommonTextFieldWithFocus(
                  //   controller: requirementController,
                  //   labelText: "Requirement",
                  //   hintText: "Requirement",
                  //   maxLines: 2,
                  // ),
                  // HtmlEditorWidget(
                  //     jdDescriptionController: requirementController,
                  //     initialText: "Initial Text",
                  //     onValueChanged: (value) async {
                  //       String? html = await requirementController.getText();
                  //       String plainText =
                  //           Bidi.stripHtmlIfNeeded(html ?? "").trim();
                  //       print("Plain Text: $plainText");
                  //     }),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: siteContextController,
                    labelText: "Site Context",
                    hintText: "Site Context",
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 10),
                  _images.isNotEmpty
                      ? SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 400,
                                width: double.infinity,
                                margin: const EdgeInsets.all(8.00),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                ),
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
                            title: 'Add Image',
                            onPressed: _getImage,
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
      );
    });
  }
}
//Distribute