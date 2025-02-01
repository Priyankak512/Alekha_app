import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  TextEditingController decisionController = TextEditingController();
  TextEditingController decisionPendingController = TextEditingController();
  TextEditingController changesOnSiteController = TextEditingController();
  TextEditingController nextOnSiteController = TextEditingController();

  File? _image;
  List<File> _images = [];

  int _currentStep = 0;

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    Uint8List imageData =
        (await rootBundle.load(PickImages.alekhaArchitectsIcon))
            .buffer
            .asUint8List();

    // Retrieve selected project category and project number
    String selectedCategory = _selectedProjectCategory ?? '';
    String projectNumber = projectNumberController.text;

    // Concatenate selected project category and project number
    String formattedProject = '$selectedCategory-$projectNumber';

    // Add pages to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 170, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      decoration: pw.BoxDecoration(
                        image: pw.DecorationImage(
                            image: pw.MemoryImage(imageData),
                            // Load image from memory
                            fit: pw.BoxFit.fill),
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Ar. Ronak Surendra Jain",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                              color: PdfColor.fromHex("#424242")),
                        ),
                        pw.Text(
                          "93760 73577",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                              color: PdfColor.fromHex("#424242")),
                        ),
                        pw.SizedBox(height: 15),
                        pw.Text(
                          "Ar. Tushar N. Kachhadiya",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                              color: PdfColor.fromHex("#424242")),
                        ),
                        pw.Text(
                          "87588 23271",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                              color: PdfColor.fromHex("#424242")),
                        ),
                      ],
                    ),
                  ]),
              pw.SizedBox(height: 6),
              // pw.Divider(color: PdfColor.fromHex("#616161"), height: 5),
              pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Site Inspection",
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
              // Client Name
              _buildTextFieldRow(
                  'Client Name : ', clientNameController.text, pdf),

              // Add selected project category and formatted project number
              _buildTextFieldRow('Project Number : ', formattedProject, pdf),

              // Site Visit Number
              _buildTextFieldRow(
                  'Site Visit Number :', siteVisitNumber.text, pdf),

              // Date
              _buildTextFieldRow('Date : ', dateController.text, pdf),

              // Work Stage On Site
              _buildTextFieldRow(
                  'Work Stage On Site : ', workStageOnSiteController.text, pdf),

              // Decision
              _buildTextFieldRow('Decision :', decisionController.text, pdf),

              // Changes On Site
              _buildTextFieldRow(
                  'Decision Pending : ', decisionPendingController.text, pdf),

              // Decision Pending
              _buildTextFieldRow(
                  'Changes On Site : ', changesOnSiteController.text, pdf),

              // Next On Site
              _buildTextFieldRow(
                  'Next On Site : ', nextOnSiteController.text, pdf),
            ],
          );
        },
      ),
    );

    for (var imageFile in _images) {
      final image = pw.MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }

    // Save and share the generated PDF
    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
        bytes: bytes, filename: 'âlekha architects - Site Inspection');
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
    return Scaffold(
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
            color: PickColors.hintColor,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Site Visit Report',
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
              CommonTextFieldWithFocus(
                controller: siteVisitNumber,
                labelText: "Site Visit No.",
                hintText: "Site Visit No.",
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
                            style: CommonTextStyle().textFieldTitleTextStyle,
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
              CommonTextFieldWithBorder(
                fillColor: Colors.transparent,
                filled: true,
                prefix: Padding(
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
                    dateController.text = formattedDate; // Set the picked date
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
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: decisionController,
                labelText: "Decisions",
                hintText: "Decisions",
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: decisionPendingController,
                labelText: "Decisions pending",
                hintText: "Decisions pending",
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: changesOnSiteController,
                labelText: "Changes on site",
                hintText: "Changes on site",
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: nextOnSiteController,
                labelText: "Next on site",
                hintText: "Next on site",
                maxLines: 2,
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
    );
  }
}
