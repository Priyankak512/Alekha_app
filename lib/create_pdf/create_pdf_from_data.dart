// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:alekha/widget/common_text_field.dart';
// import 'package:alekha/widget/get_date_function.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CreatePdfFromData extends StatefulWidget {
//   const CreatePdfFromData({Key? key}) : super(key: key);

//   @override
//   State<CreatePdfFromData> createState() => _CreatePdfFromDataState();
// }

// class _CreatePdfFromDataState extends State<CreatePdfFromData> {
//   DateFormat normalDateFormate = DateFormat('dd/MM/yyyy');

//   TextEditingController clientNameController = TextEditingController();
//   TextEditingController projectNumberController = TextEditingController();
//   TextEditingController siteVisitNumber = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//   TextEditingController workStageOnSiteController = TextEditingController();
//   TextEditingController decisionController = TextEditingController();
//   TextEditingController decisionPendingController = TextEditingController();
//   TextEditingController changesOnSiteController = TextEditingController();
//   TextEditingController nextOnSiteController = TextEditingController();

//   File? _image;
//   List<File> _images = [];

//   Future<void> _generatePDF() async {
//     final pdf = pw.Document();

//     for (var imageFile in _images) {
//       final image = pw.MemoryImage(imageFile.readAsBytesSync());
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Center(child: pw.Image(image));
//           },
//         ),
//       );
//     }

//     // Add pages to the PDF document
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Title
//               pw.Text(
//                 'Project Report',
//                 style:
//                     pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(height: 10), // Add some spacing

//               // Client Name
//               _buildTextFieldRow('Client Name:', clientNameController.text),

//               // Project Number
//               _buildTextFieldRow('Project Number:', dateController.text),

//               // Date
//               _buildTextFieldRow(
//                   'Project Number :', projectNumberController.text),

//               // Site Visit Number
//               _buildTextFieldRow('Site Visit Number:', siteVisitNumber.text),

//               // Work Stage On Site
//               _buildTextFieldRow(
//                   'Work Stage On Site:', workStageOnSiteController.text),

//               // Decision
//               _buildTextFieldRow('Decision:', decisionController.text),

//               // Decision Pending
//               _buildTextFieldRow(
//                   'Decision Pending:', decisionPendingController.text),

//               // Changes On Site
//               _buildTextFieldRow(
//                   'Changes On Site:', changesOnSiteController.text),

//               // Next On Site
//               _buildTextFieldRow('Next On Site:', nextOnSiteController.text),

//               // Add images
//               for (var imageFile in _images)
//                 pw.Container(
//                   width: double.infinity,
//                   height: 400, // Set a fixed height for each image container
//                   margin: const pw.EdgeInsets.all(8.00),
//                   child: pw.Image(pw.MemoryImage(imageFile.readAsBytesSync())),
//                 ),
//             ],
//           );
//         },
//       ),
//     );

//     // Save and share the generated PDF
//     final Uint8List bytes = await pdf.save();
//     await Printing.sharePdf(bytes: bytes, filename: 'project_report.pdf');
//   }

//   // Helper function to build a row of text fields
//   pw.Widget _buildTextFieldRow(String label, String value) {
//     return pw.Container(
//       margin: const pw.EdgeInsets.only(bottom: 5),
//       child: pw.Row(
//         children: [
//           pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//           pw.Text(value, style: const pw.TextStyle()),
//         ],
//       ),
//     );
//   }

//   Future<void> _getImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(
//       () {
//         if (pickedFile != null) {
//           _images.add(File(pickedFile.path));
//         } else {
//           debugPrint("No Image selected");
//         }
//       },
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Generator'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Focus(
//                 child: TextField(
//                   maxLines: 2,
//                   controller: clientNameController,
//                   onSubmitted: (String value) {
//                     debugPrint('\n*** onSubmitted: $value ***\n');
//                   },
//                 ),
//                 onFocusChange: (value) {
//                   if (!value) {
//                     debugPrint(
//                         '\n*** onFocusChange: ${clientNameController.text} ***\n');
//                   }
//                 },
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: true,
//                 labelText: "Project No.",
//                 hint: "Enter Project No.",
//                 controller: projectNumberController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Site Visit No.",
//                 hint: "Enter Site Visit No.",
//                 controller: siteVisitNumber,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 "Date",
//               ),
//               CommonTextFieldWithBorder(
//                 fillColor: Colors.white,
//                 filled: true,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child:
//                       Icon(Icons.calendar_month_outlined, color: Colors.teal),
//                 ),
//                 isRequired: true,
//                 readOnly: true,
//                 hint: "Date",
//                 controller: dateController,
//                 textInputAction: TextInputAction.none,
//                 keyboardType: TextInputType.none,
//                 validator: (value) {},
//                 onTap: () async {
//                   DateTime? pickedDate = await getDateFunction(
//                     isOldDate: true,
//                     context: context,
//                   );
//                   if (pickedDate != null) {
//                     String formattedDate = normalDateFormate.format(pickedDate);
//                     dateController.text = formattedDate; // Set the picked date
//                   }
//                 },
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Work Stage on Site",
//                 hint: "Enter Work Stage on Site",
//                 controller: workStageOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Decisions",
//                 hint: "Enter Decisions",
//                 controller: decisionController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Decisions pending",
//                 hint: "Enter Decisions pending",
//                 controller: decisionPendingController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Changes on site",
//                 hint: "Enter Changes on site",
//                 controller: changesOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Next on site",
//                 hint: "Enter Next on site",
//                 controller: nextOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 10),
//               _images.isNotEmpty
//                   ? SizedBox(
//                       height: 400,
//                       child: ListView.builder(
//                         itemCount: _images.length,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             height: 400,
//                             width: double.infinity,
//                             margin: const EdgeInsets.all(8.00),
//                             child: Image.file(
//                               _images[index],
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         },
//                       ),
//                     )
//                   : Container(),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _getImage,
//                 child: const Text('Add Image'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _generatePDF,
//                 child: const Text('Create PDF'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:alekha_project/Service/date_picker_function.dart';
// import 'package:alekha_project/widget/common_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _CreatePdfFromDataState();
// }
//
// class _CreatePdfFromDataState extends State<HomeScreen> {
//   DateFormat normalDateFormate = DateFormat('dd/MM/yyyy');
//
//   TextEditingController clientNameController = TextEditingController();
//   TextEditingController projectNumberController = TextEditingController();
//   TextEditingController siteVisitNumber = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//   TextEditingController workStageOnSiteController = TextEditingController();
//   TextEditingController decisionController = TextEditingController();
//   TextEditingController decisionPendingController = TextEditingController();
//   TextEditingController changesOnSiteController = TextEditingController();
//   TextEditingController nextOnSiteController = TextEditingController();
//
//   File? _image;
//
//   List<File> _images = [];
//   Future<void> _generatePDF() async {
//     final pdf = pw.Document();
//     List<pw.Widget> imageWidgets = [];
//     createPDF() {
//       for (var imageFile in _images) {
//         imageWidgets.add(
//           pw.Container(
//             width: double.infinity,
//             height: 400, // Set a fixed height for each image
// //  container
//             margin: const pw.EdgeInsets.all(8.00),
//             child: pw.Image(
//               pw.MemoryImage(imageFile.readAsBytesSync()),
//             ),
//           ),
//         );
//         final image = pw.MemoryImage(imageFile.readAsBytesSync());
//         pdf.addPage(pw.Page(
//             // pageFormat: PdfPageFormat.a4,
//             build: (pw.Context context) {
//           return pw.Center(child: pw.Image(image));
//         }));
//       }
//     }
//
//     // Define styles for text
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Title
//               pw.Text(
//                 'Alekha Architects ',
//                 style:
//                     pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(height: 15), // Add some spacing
//
//               // Client Name
//               _buildTextFieldRow(
//                   'Client Name:', clientNameController.text, pdf),
//
//               // Project Number
//               _buildTextFieldRow('Date:', dateController.text, pdf),
//
//               // Date
//               _buildTextFieldRow(
//                   'Project Number :', projectNumberController.text, pdf),
//
//               // Site Visit Number
//               _buildTextFieldRow(
//                   'Site Visit Number :', siteVisitNumber.text, pdf),
//
//               // Work Stage On Site
//               _buildTextFieldRow(
//                   'Work Stage On Site :', workStageOnSiteController.text, pdf),
//
//               // Decision
//               _buildTextFieldRow('Decision :', decisionController.text, pdf),
//
//               // Decision Pending
//               _buildTextFieldRow(
//                   'Decision Pending :', decisionPendingController.text, pdf),
//
//               // Changes On Site
//               _buildTextFieldRow(
//                   'Changes On Site :', changesOnSiteController.text, pdf),
//
//               // Next On Site
//               _buildTextFieldRow(
//                   'Next On Site :', nextOnSiteController.text, pdf),
//               //  Add images
//               ...imageWidgets,
//             ],
//           );
//         },
//       ),
//     );
//
//     // Save and share the generated PDF
//     final Uint8List bytes = await pdf.save();
//     await Printing.sharePdf(bytes: bytes, filename: 'project_report.pdf');
//   }
//
//   // Helper function to build a row of text fields
//   // Helper function to build a row of text fields
//   pw.Widget _buildTextFieldRow(String label, String value, pw.Document pdf) {
//     if (value.isNotEmpty) {
//       return pw.Container(
//         margin: const pw.EdgeInsets.only(bottom: 5),
//         child: pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               label,
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text(
//               value,
//               style: pw.TextStyle(),
//             ),
//             pw.SizedBox(height: 5),
//           ],
//         ),
//       );
//     } else {
//       return pw.SizedBox(); // Return an empty SizedBox if value is empty
//     }
//   }
//
//   // Future<void> _getImage() async {
//   //   final pickedFile =
//   //       await ImagePicker().pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //     });
//   //   }
//   // }
//   Future<void> _getImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(
//       () {
//         if (pickedFile != null) {
//           _images.add(File(pickedFile.path));
//         } else {
//           debugPrint("No Image selected");
//         }
//       },
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Generator'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CommonTextFieldWithBorder(
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: true,
//                 labelText: "Client Name",
//                 hint: "Enter Client Name",
//                 controller: clientNameController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: true,
//                 labelText: "Project No.",
//                 hint: "Enter Project No.",
//                 controller: projectNumberController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Site Visit No.",
//                 hint: "Enter Site Visit No.",
//                 controller: siteVisitNumber,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               const Text("Date"),
//               CommonTextFieldWithBorder(
//                 fillColor: Colors.white,
//                 filled: true,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child:
//                       Icon(Icons.calendar_month_outlined, color: Colors.teal),
//                 ),
//                 isRequired: true,
//                 readOnly: true,
//                 hint: "Date",
//                 controller: dateController,
//                 textInputAction: TextInputAction.none,
//                 keyboardType: TextInputType.none,
//                 validator: (value) {},
//                 onTap: () async {
//                   DateTime? pickedDate = await getDateFunction(
//                     isOldDate: true,
//                     context: context,
//                   );
//                   if (pickedDate != null) {
//                     String formattedDate = normalDateFormate.format(pickedDate);
//                     dateController.text = formattedDate; // Set the picked date
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Work Stage on Site",
//                 hint: "Enter Work Stage on Site",
//                 controller: workStageOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Decisions",
//                 hint: "Enter Decisions",
//                 controller: decisionController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Decisions pending",
//                 hint: "Enter Decisions pending",
//                 controller: decisionPendingController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Changes on site",
//                 hint: "Enter Changes on site",
//                 controller: changesOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               CommonTextFieldWithBorder(
//                 maxLines: 10,
//                 prefix: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 isRequired: false,
//                 labelText: "Next on site",
//                 hint: "Enter Next on site",
//                 controller: nextOnSiteController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 20),
//               _images != null
//                   ? SizedBox(
//                       height: 400,
//                       child: ListView.builder(
//                           itemCount: _images.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               height: 400,
//                               width: double.infinity,
//                               margin: const EdgeInsets.all(8.00),
//                               child: Image.file(
//                                 _images[index],
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           }),
//                     )
//                   : Container(),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _getImage,
//                 child: const Text('Add Image'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _generatePDF,
//                 child: const Text('Create PDF'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreatePdfFromData extends StatefulWidget {
  const CreatePdfFromData({Key? key}) : super(key: key);

  @override
  State<CreatePdfFromData> createState() => _CreatePdfFromDataState();
}

class _CreatePdfFromDataState extends State<CreatePdfFromData> {
  DateFormat normalDateFormate = DateFormat('dd/MM/yyyy');

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

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    Uint8List imageData =
        (await rootBundle.load('assets/images/house.jpg')).buffer.asUint8List();

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
                      width: 150, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                      decoration: pw.BoxDecoration(
                        image: pw.DecorationImage(
                          image: pw.MemoryImage(
                              imageData), // Load image from memory
                        ),
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "John Patel Doctor",
                          style: pw.TextStyle(
                              fontSize: 15, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.Text(
                          "2020 542515",
                          style: pw.TextStyle(
                              fontSize: 15, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.SizedBox(height: 15),
                        pw.Text(
                          "Chandu Patel Doctor",
                          style: pw.TextStyle(
                              fontSize: 15, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.Text(
                          "2020 50005",
                          style: pw.TextStyle(
                              fontSize: 15, fontWeight: pw.FontWeight.normal),
                        ),
                      ],
                    ),
                  ]),

              pw.SizedBox(height: 5), // Add some spacing
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
              pw.Divider(),

              // Client Name
              _buildTextFieldRow(
                  'Client Name :', clientNameController.text, pdf),

              // Project Number
              _buildTextFieldRow(
                  'Project Number :', projectNumberController.text, pdf),

              // Site Visit Number
              _buildTextFieldRow(
                  'Site Visit Number:', siteVisitNumber.text, pdf),

              // Date
              _buildTextFieldRow('Date : ', dateController.text, pdf),

              // Work Stage On Site
              _buildTextFieldRow(
                  'Work Stage On Site:', workStageOnSiteController.text, pdf),

              // Decision
              _buildTextFieldRow('Decision:', decisionController.text, pdf),

              // Changes On Site
              _buildTextFieldRow(
                  'Decision Pending:', decisionPendingController.text, pdf),

              // Decision Pending
              _buildTextFieldRow(
                  'Changes On Site:', changesOnSiteController.text, pdf),

              // Next On Site
              _buildTextFieldRow(
                  'Next On Site:', nextOnSiteController.text, pdf),

              // Add images
              // for (var imageFile in _images)
              //   pw.Container(
              //     width: double.infinity,
              //     height: 400, // Set a fixed height for each image container
              //     margin: const pw.EdgeInsets.all(8.00),
              //     child: pw.Image(pw.MemoryImage(imageFile.readAsBytesSync())),
              //   ),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                "g kg g gvfgvr fgvkrtfgv fgvmrf gvrtfmgvr tfgvmrtf gvbrtfmbv tfmbrf",
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.normal),
              ),
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
    await Printing.sharePdf(bytes: bytes, filename: 'project_report.pdf');
  }

  // Helper function to build a row of text fields
  pw.Widget _buildTextFieldRow(String label, String value, pw.Document pdf) {
    if (value.isNotEmpty) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              value,
              style: const pw.TextStyle(),
            ),
            pw.SizedBox(height: 5),
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
      appBar: AppBar(
        title: const Text('PDF Generator'),
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
              CommonTextFieldWithBorder(
                fillColor: Colors.transparent,
                filled: true,
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child:
                      Icon(Icons.calendar_month_outlined, color: Colors.teal),
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
                    String formattedDate = normalDateFormate.format(pickedDate);
                    dateController.text = formattedDate; // Set the picked date
                  }
                },
                borderRadius: BorderRadius.circular(05),
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
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Add Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generatePDF,
                child: const Text('Create PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonTextFieldWithFocus extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final dynamic keyboardType;
  final void Function(String)? onSubmitted;
  final void Function(bool)? onFocusChange;

  const CommonTextFieldWithFocus({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.maxLines = 1,
    this.onSubmitted,
    this.textInputAction,
    this.onFocusChange,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border:
              const OutlineInputBorder(), // Add a border around the TextField
        ),
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
      ),
    );
  }
}
