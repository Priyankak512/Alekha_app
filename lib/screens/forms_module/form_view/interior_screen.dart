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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InteriorScreen extends StatefulWidget {
  const InteriorScreen({Key? key}) : super(key: key);

  @override
  State<InteriorScreen> createState() => _CreatePdfFromDataState();
}

class _CreatePdfFromDataState extends State<InteriorScreen> {
  String? _selectedProjectType;
  String? _selectedCategory;
  String? _selectedHiringInteriorDesigner;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController carpetAreaController = TextEditingController();
  TextEditingController builtUpAreaController = TextEditingController();
  TextEditingController noOfUsersController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();

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

    // Retrieve selected project category and project number
    String selectedCategory = _selectedProjectType ?? '';

    // Add pages to the PDF document
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
                              // pw.Expanded(
                              //   child:
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
                          pw.Divider(
                              height: 3, color: PdfColor.fromHex("#616161")),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Interior Form",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: pw.FontWeight.normal),
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
                          // Client Name
                          _buildTextFieldRow(
                              'Client Name : ', clientNameController.text, pdf),

                          // Contact Number
                          _buildTextFieldRow(
                              'Contact No. : ', contactNoController.text, pdf),

                          // Date
                          _buildTextFieldRow(
                              'Date :', dateController.text, pdf),

                          // Address
                          _buildTextFieldRow(
                              'Address : ', addressController.text, pdf),

                          // Project Type
                          _buildTextFieldRow('Project Type : ',
                              _selectedProjectType.toString(), pdf),

                          // Category
                          _buildTextFieldRow(
                              'Category :', _selectedCategory.toString(), pdf),

                          // Carpet Area
                          _buildTextFieldRow(
                              'Carpet Area : ', carpetAreaController.text, pdf),

                          // Built-Up-Area
                          _buildTextFieldRow('Built-Up-Area : ',
                              builtUpAreaController.text, pdf),

                          // No. of users
                          _buildTextFieldRow(
                              'No. Of Users : ', noOfUsersController.text, pdf),

                          // Budget
                          _buildTextFieldRow(
                              'Budget : ', budgetController.text, pdf),

                          // Hiring Designers
                          _buildTextFieldRow('Hiring Interior Designer/s For :',
                              _selectedHiringInteriorDesigner.toString(), pdf),

                          // Requirements
                          _buildTextFieldRow('Requirements : ',
                              requirementsController.text, pdf),
                        ],
                      ))));
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

    // // Save and share the generated PDF
    await Printing.layoutPdf(
      name:
          'INT FORM ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    // final Uint8List bytes = await pdf.save();
    // await Printing.sharePdf(
    //     bytes: bytes, filename: 'âlekha architects - Site Inspection');
    // //Print the PDF or show preview
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());
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
              'Interior Form',
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
                    controller: contactNoController,
                    labelText: "Contact No.",
                    hintText: "Contact No.",
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
                    items: GlobalList.interiorProjectTypeList
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
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Category Type",
                    name: 'Category Type',
                    items: GlobalList.interiorCategoryList
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
                    initialValue: _selectedCategory,
                    onChanged: (newValue) {
                      setState(
                        () {
                          _selectedCategory = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedCategory");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: carpetAreaController,
                    labelText: "Carpet Area",
                    hintText: "Carpet Area",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: builtUpAreaController,
                    labelText: "Built-Up-Area",
                    hintText: "Built-Up-Area",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: noOfUsersController,
                    labelText: "No. Of Users",
                    hintText: "No. Of Users",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: budgetController,
                    labelText: "Budget",
                    hintText: "Budget",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Hiring Interior Designer/S For",
                    name: 'Hiring Interior Designer/S For',
                    items: GlobalList.hiringInteriorDesignerList
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
                    initialValue: _selectedHiringInteriorDesigner,
                    onChanged: (newValue) {
                      setState(
                        () {
                          _selectedHiringInteriorDesigner = newValue.toString();
                        },
                      );
                      debugPrint("----------$_selectedHiringInteriorDesigner");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFieldWithFocus(
                    controller: requirementsController,
                    labelText: "Requirements",
                    hintText: "Requirements",
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
