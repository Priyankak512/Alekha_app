import 'dart:io';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
import 'package:alekha/screens/meeting_module/meeting_view/meeting_screen.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_image_picker.dart';
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
  String? _selectedTimeStatus;

  File? _image;
  List<File> _images = [];

  TextEditingController clientNameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController selectionTimeController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController selectionVisitNumber = TextEditingController();

  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  TextEditingController description3Controller = TextEditingController();
  TextEditingController description4Controller = TextEditingController();
  TextEditingController description5Controller = TextEditingController();
  TextEditingController description6Controller = TextEditingController();
  TextEditingController description7Controller = TextEditingController();
  TextEditingController description8Controller = TextEditingController();

  // Future<void> _generatePDF() async {
  //   final pdf = pw.Document();

  //   Uint8List imageData =
  //       (await rootBundle.load(PickImages.alekhaArchitectsIcon))
  //           .buffer
  //           .asUint8List();
  //   Uint8List invoiceContactPdfLogo =
  //       (await rootBundle.load(PickImages.siteVisitContactsPdfImage))
  //           .buffer
  //           .asUint8List();

  //   // Concatenate selected project category and project number
  //   String formattedProject =
  //       "${projectNumberController.text} ${_selectedProjectType == 'Architecture - A' ? 'A' : _selectedProjectType == 'Interior - I' ? 'I' : _selectedProjectType == 'Architecture Interior - AI' ? 'AI' : ''}";

  //   // सभी descriptions एक list में
  //   final descriptions = [
  //     description1Controller.text,
  //     description2Controller.text,
  //     description3Controller.text,
  //     description4Controller.text,
  //     description5Controller.text,
  //     description6Controller.text,
  //     description7Controller.text,
  //     description8Controller.text,
  //   ];

  //   // --- Header Widget
  //   pw.Widget _buildHeader() {
  //     return pw.Column(
  //       children: [
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Container(
  //               width: 170,
  //               height: 60,
  //               margin: const pw.EdgeInsets.only(bottom: 2),
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(imageData),
  //                   fit: pw.BoxFit.fill,
  //                 ),
  //               ),
  //             ),
  //             pw.Container(
  //               width: 120,
  //               height: 60,
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(invoiceContactPdfLogo),
  //                   fit: pw.BoxFit.contain,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         pw.SizedBox(height: 6),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Text(
  //               "SELECTION",
  //               style: pw.TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.Text(
  //               "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
  //               style: pw.TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: pw.FontWeight.normal,
  //                   color: PdfColor.fromHex("#616161")),
  //             ),
  //           ],
  //         ),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
  //         pw.SizedBox(height: 5),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Client Name : ',
  //                 clientNameController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Project No. : ',
  //                 formattedProject,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Address : ',
  //                 addressController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Selection Visit No. : ',
  //                 selectionVisitNumber.text,
  //               ),
  //             ),
  //           ],
  //         ),
  //         // _buildTextFieldRow(
  //         //     'Selection Time :', "${selectionTimeController.text+ _selectedTimeStatus.toString()}", pdf),
  //         pw.SizedBox(height: 10),
  //       ],
  //     );
  //   }

  //   // --- Description + Image Pair Widget
  //   pw.Widget _buildDescriptionWithImage(String description, File? imageFile) {
  //     if (description.isEmpty && imageFile == null) {
  //       return pw.SizedBox();
  //     }

  //     return pw.Container(
  //       margin: const pw.EdgeInsets.symmetric(vertical: 8),
  //       child: pw.Row(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           // Description
  //           pw.Expanded(
  //             flex: 2,
  //             child: pw.Text(
  //               description,
  //               style: const pw.TextStyle(fontSize: 12),
  //             ),
  //           ),
  //           pw.SizedBox(width: 10),
  //           // Image with border radius
  //           if (imageFile != null)
  //             pw.Expanded(
  //               flex: 2,
  //               child: pw.ClipRRect(
  //                 horizontalRadius: 8,
  //                 verticalRadius: 8,
  //                 child: pw.Container(
  //                   decoration: pw.BoxDecoration(
  //                     borderRadius: pw.BorderRadius.circular(8),
  //                     border: pw.Border.all(
  //                       color: PdfColors.grey,
  //                       width: 0.5,
  //                     ),
  //                   ),
  //                   child: pw.Image(
  //                     pw.MemoryImage(imageFile.readAsBytesSync()),
  //                     fit: pw.BoxFit.cover,
  //                     height: 150, // equal height for all images
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     );
  //   }

  //   // 🔹 अब pages बनाना (हर page में 3 pairs)
  //   for (int i = 0; i < descriptions.length; i += 3) {
  //     pdf.addPage(
  //       pw.Page(
  //         margin: const pw.EdgeInsets.all(20),
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context context) {
  //           return pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               _buildHeader(),
  //               if (i < descriptions.length)
  //                 _buildDescriptionWithImage(
  //                     descriptions[i], i < _images.length ? _images[i] : null),
  //               if (i + 1 < descriptions.length)
  //                 _buildDescriptionWithImage(descriptions[i + 1],
  //                     i + 1 < _images.length ? _images[i + 1] : null),
  //               if (i + 2 < descriptions.length)
  //                 _buildDescriptionWithImage(descriptions[i + 2],
  //                     i + 2 < _images.length ? _images[i + 2] : null),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   }

  //   // Print the PDF
  //   await Printing.layoutPdf(
  //       name:
  //           '${projectNumberController.text} SELECTION ${dateMeetingController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
  //       onLayout: (PdfPageFormat format) async => pdf.save());
  // }

  // Future<void> _generatePDF() async {
  //   final pdf = pw.Document();

  //   Uint8List imageData =
  //       (await rootBundle.load(PickImages.alekhaArchitectsIcon))
  //           .buffer
  //           .asUint8List();
  //   Uint8List invoiceContactPdfLogo =
  //       (await rootBundle.load(PickImages.siteVisitContactsPdfImage))
  //           .buffer
  //           .asUint8List();

  //   // Concatenate selected project category and project number
  //   String formattedProject =
  //       "${projectNumberController.text} ${_selectedProjectType == 'Architecture - A' ? 'A' : _selectedProjectType == 'Interior - I' ? 'I' : _selectedProjectType == 'Architecture Interior - AI' ? 'AI' : ''}";

  //   // सभी descriptions एक list में
  //   final descriptions = [
  //     description1Controller.text,
  //     description2Controller.text,
  //     description3Controller.text,
  //     description4Controller.text,
  //     description5Controller.text,
  //     description6Controller.text,
  //     description7Controller.text,
  //     description8Controller.text,
  //   ];

  //   // --- Header Widget
  //   pw.Widget _buildHeader() {
  //     return pw.Column(
  //       children: [
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Container(
  //               width: 170,
  //               height: 60,
  //               margin: const pw.EdgeInsets.only(bottom: 2),
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(imageData),
  //                   fit: pw.BoxFit.fill,
  //                 ),
  //               ),
  //             ),
  //             pw.Container(
  //               width: 120,
  //               height: 60,
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(invoiceContactPdfLogo),
  //                   fit: pw.BoxFit.contain,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         pw.SizedBox(height: 6),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Text(
  //               "SELECTION",
  //               style: pw.TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.Text(
  //               "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
  //               style: pw.TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: pw.FontWeight.normal,
  //                   color: PdfColor.fromHex("#616161")),
  //             ),
  //           ],
  //         ),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
  //         pw.SizedBox(height: 5),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Client Name : ',
  //                 clientNameController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Project No. : ',
  //                 formattedProject,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Address : ',
  //                 addressController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Selection Visit No. : ',
  //                 selectionVisitNumber.text,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.SizedBox(height: 10),
  //       ],
  //     );
  //   }

  //   // --- Description + Image Pair Widget
  //   pw.Widget _buildImageWithDescription(
  //       List<File> images, List<String> descriptions, int index) {
  //     if (index >= images.length) {
  //       return pw.SizedBox(); // agar image hi nahi hai to skip
  //     }

  //     return pw.Expanded(
  //       child: pw.Container(
  //         margin: const pw.EdgeInsets.all(8),
  //         decoration: pw.BoxDecoration(
  //           border: pw.Border.all(color: PdfColors.grey, width: 0.5),
  //           borderRadius: pw.BorderRadius.circular(12),
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             // ---- Image with border radius
  //             pw.ClipRRect(
  //               horizontalRadius: 12,
  //               verticalRadius: 12,
  //               child: pw.Image(
  //                 pw.MemoryImage(images[index].readAsBytesSync()),
  //                 fit: pw.BoxFit.contain,
  //                 height: 180, // equal height for all images
  //               ),
  //             ),
  //             pw.SizedBox(height: 6),

  //             // ---- Description under image
  //             pw.Text(
  //               index < descriptions.length ? descriptions[index] : "",
  //               style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //               textAlign: pw.TextAlign.center,
  //             ),
  //             pw.SizedBox(height: 4),
  //           ],
  //         ),
  //       ),
  //     );
  //   }

  //   // ✅ पहले valid pairs filter करेंगे
  //   final validPairs = <Map<String, dynamic>>[];
  //   for (int i = 0; i < descriptions.length; i++) {
  //     if (descriptions[i].trim().isNotEmpty ||
  //         (i < _images.length && _images[i] != null)) {
  //       validPairs.add({
  //         "description": descriptions[i],
  //         "image": i < _images.length ? _images[i] : null,
  //       });
  //     }
  //   }

  //   if (validPairs.isEmpty) {
  //     // ❌ Empty case → कम से कम 1 page बनाओ
  //     pdf.addPage(
  //       pw.Page(
  //         margin: const pw.EdgeInsets.all(20),
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context context) {
  //           return pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               _buildHeader(),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     // 🔹 pages बनाना (हर page में 3 pairs)
  //     for (int i = 0; i < validPairs.length; i += 3) {
  //       pdf.addPage(
  //         pw.Page(
  //           margin: const pw.EdgeInsets.all(20),
  //           pageFormat: PdfPageFormat.a4,
  //           build: (pw.Context context) {
  //             return pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 _buildHeader(),
  //                 if (i < validPairs.length)
  //                   _buildDescriptionWithImage(
  //                       validPairs[i]["description"], validPairs[i]["image"]),
  //                 if (i + 1 < validPairs.length)
  //                   _buildDescriptionWithImage(validPairs[i + 1]["description"],
  //                       validPairs[i + 1]["image"]),
  //                 if (i + 2 < validPairs.length)
  //                   _buildDescriptionWithImage(validPairs[i + 2]["description"],
  //                       validPairs[i + 2]["image"]),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     }
  //   }

  //   // Print the PDF
  //   await Printing.layoutPdf(
  //     name:
  //         '${projectNumberController.text} SELECTION ${dateMeetingController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }

  // pw.Widget _buildDescriptionWithImage(String description, File? imageFile) {
  //   if (description.isEmpty && imageFile == null) {
  //     return pw.SizedBox(); // skip agar dono empty
  //   }

  //   return pw.Container(
  //     margin: const pw.EdgeInsets.symmetric(vertical: 8),
  //     child: pw.Row(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         // ---- Description (Left side)
  //         pw.Expanded(
  //           flex: 2,
  //           child: pw.Text(
  //             description,
  //             style: const pw.TextStyle(fontSize: 12),
  //           ),
  //         ),
  //         pw.SizedBox(width: 10),

  //         // ---- Image (Right side with border radius)
  //         if (imageFile != null)
  //           pw.Expanded(
  //             flex: 2,
  //             child: pw.ClipRRect(
  //               horizontalRadius: 8,
  //               verticalRadius: 8,
  //               child: pw.Container(
  //                 decoration: pw.BoxDecoration(
  //                   borderRadius: pw.BorderRadius.circular(8),
  //                   border: pw.Border.all(
  //                     color: PdfColors.grey,
  //                     width: 0.5,
  //                   ),
  //                 ),
  //                 child: pw.Image(
  //                   pw.MemoryImage(imageFile.readAsBytesSync()),
  //                   fit: pw.BoxFit.cover,
  //                   height: 150, // fixed height
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // // Helper function to build a row of text fields
  // pw.Widget _buildTextFieldRow(String label, String value, pw.Document pdf) {
  //   if (value.isNotEmpty) {
  //     return pw.Container(
  //       margin: const pw.EdgeInsets.only(bottom: 5),
  //       child: pw.Row(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           pw.Text(
  //             label,
  //             style: pw.TextStyle(
  //               fontWeight: pw.FontWeight.bold,
  //               fontSize: 13, // Adjust font size for label
  //             ),
  //           ),
  //           pw.Text(
  //             value,
  //             style: const pw.TextStyle(
  //               fontSize: 13, // Adjust font size for value
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return pw.SizedBox(); // Return an empty SizedBox if value is empty
  //   }
  // }
  // Future<void> _generatePDF() async {
  //   final pdf = pw.Document();

  //   Uint8List imageData =
  //       (await rootBundle.load(PickImages.alekhaArchitectsIcon))
  //           .buffer
  //           .asUint8List();
  //   Uint8List invoiceContactPdfLogo =
  //       (await rootBundle.load(PickImages.siteVisitContactsPdfImage))
  //           .buffer
  //           .asUint8List();

  //   // Concatenate selected project category and project number
  //   String formattedProject =
  //       "${projectNumberController.text} ${_selectedProjectType == 'Architecture - A' ? 'A' : _selectedProjectType == 'Interior - I' ? 'I' : _selectedProjectType == 'Architecture Interior - AI' ? 'AI' : ''}";

  //   // सभी descriptions एक list में
  //   final descriptions = [
  //     description1Controller.text,
  //     description2Controller.text,
  //     description3Controller.text,
  //     description4Controller.text,
  //     description5Controller.text,
  //     description6Controller.text,
  //     description7Controller.text,
  //     description8Controller.text,
  //   ];

  //   // --- Header Widget
  //   pw.Widget _buildHeader() {
  //     return pw.Column(
  //       children: [
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Container(
  //               width: 170,
  //               height: 60,
  //               margin: const pw.EdgeInsets.only(bottom: 2),
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(imageData),
  //                   fit: pw.BoxFit.fill,
  //                 ),
  //               ),
  //             ),
  //             pw.Container(
  //               width: 120,
  //               height: 60,
  //               decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(
  //                   image: pw.MemoryImage(invoiceContactPdfLogo),
  //                   fit: pw.BoxFit.contain,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         pw.SizedBox(height: 6),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Text(
  //               "SELECTION",
  //               style: pw.TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.Text(
  //               "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
  //               style: pw.TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: pw.FontWeight.normal,
  //                   color: PdfColor.fromHex("#616161")),
  //             ),
  //           ],
  //         ),
  //         pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
  //         pw.SizedBox(height: 5),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Client Name : ',
  //                 clientNameController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Project No. : ',
  //                 formattedProject,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Expanded(
  //               flex: 2,
  //               child: buildInlineTextFieldRow(
  //                 'Address : ',
  //                 addressController.text,
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: buildInlineTextFieldRow(
  //                 'Selection Visit No. : ',
  //                 selectionVisitNumber.text,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.SizedBox(height: 10),
  //       ],
  //     );
  //   }

  //   // --- Image + Description (single box)
  //   pw.Widget _buildImageWithDescription(int index) {
  //     if (index >= _images.length && index >= descriptions.length) {
  //       return pw.SizedBox();
  //     }

  //     final File? imageFile = index < _images.length ? _images[index] : null;
  //     final String description =
  //         index < descriptions.length ? descriptions[index] : "";

  //     return pw.Expanded(
  //       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           if (imageFile != null)
  //             pw.ClipRRect(
  //               horizontalRadius: 12,
  //               verticalRadius: 12,
  //               child: pw.Image(
  //                 pw.MemoryImage(imageFile.readAsBytesSync()),
  //                 fit: pw.BoxFit.contain,
  //                 height: 200, // same height
  //               ),
  //             ),
  //           if (description.isNotEmpty) ...[
  //             pw.SizedBox(height: 6),
  //             pw.Padding(
  //               padding: const pw.EdgeInsets.all(4),
  //               child: pw.Text(
  //                 description,
  //                 style: const pw.TextStyle(fontSize: 10),
  //                 textAlign: pw.TextAlign.center,
  //               ),
  //             ),
  //           ]
  //         ],
  //       ),
  //     );
  //   }

  //   // ✅ pages बनाना (हर page में 4 images + description)
  //   for (int i = 0; i < descriptions.length || i < _images.length; i += 4) {
  //     pdf.addPage(
  //       pw.Page(
  //         margin: const pw.EdgeInsets.all(20),
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context context) {
  //           return pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               _buildHeader(),
  //               pw.Expanded(
  //                 child: pw.Column(
  //                   children: [
  //                     pw.Expanded(
  //                       child: pw.Row(
  //                         children: [
  //                           _buildImageWithDescription(i),
  //                           _buildImageWithDescription(i + 1),
  //                         ],
  //                       ),
  //                     ),
  //                     pw.Expanded(
  //                       child: pw.Row(
  //                         children: [
  //                           _buildImageWithDescription(i + 2),
  //                           _buildImageWithDescription(i + 3),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   }

  //   // Print the PDF
  //   await Printing.layoutPdf(
  //     name:
  //         '${projectNumberController.text} SELECTION ${dateMeetingController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }

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

    // // --- Header Widget
    // pw.Widget _buildHeader() {
    //   return pw.Column(
    //     children: [
    //       pw.Row(
    //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //         children: [
    //           pw.Container(
    //             width: 170,
    //             height: 60,
    //             margin: const pw.EdgeInsets.only(bottom: 2),
    //             decoration: pw.BoxDecoration(
    //               image: pw.DecorationImage(
    //                 image: pw.MemoryImage(imageData),
    //                 fit: pw.BoxFit.fill,
    //               ),
    //             ),
    //           ),
    //           pw.Container(
    //             width: 120,
    //             height: 60,
    //             decoration: pw.BoxDecoration(
    //               image: pw.DecorationImage(
    //                 image: pw.MemoryImage(invoiceContactPdfLogo),
    //                 fit: pw.BoxFit.contain,
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //       pw.SizedBox(height: 6),
    //       pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
    //       pw.Row(
    //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //         children: [
    //           pw.Text(
    //             "SELECTION",
    //             style: pw.TextStyle(
    //               fontSize: 15,
    //               fontWeight: pw.FontWeight.bold,
    //             ),
    //           ),
    //           pw.Text(
    //             "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
    //             style: pw.TextStyle(
    //                 fontSize: 13,
    //                 fontWeight: pw.FontWeight.normal,
    //                 color: PdfColor.fromHex("#616161")),
    //           ),
    //         ],
    //       ),
    //       pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
    //       pw.SizedBox(height: 5),
    //       pw.Row(
    //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           pw.Expanded(
    //             flex: 2,
    //             child: buildInlineTextFieldRow(
    //               'Client Name : ',
    //               clientNameController.text,
    //             ),
    //           ),
    //           pw.Expanded(
    //             child: buildInlineTextFieldRow(
    //               'Project No. : ',
    //               formattedProject,
    //             ),
    //           ),
    //         ],
    //       ),
    //       pw.Row(
    //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           pw.Expanded(
    //             flex: 2,
    //             child: buildInlineTextFieldRow(
    //               'Address : ',
    //               addressController.text,
    //             ),
    //           ),
    //           pw.Expanded(
    //             child: buildInlineTextFieldRow(
    //               'Selection Visit No. : ',
    //               selectionVisitNumber.text,
    //             ),
    //           ),
    //         ],
    //       ),
    //       pw.SizedBox(height: 10),
    //     ],
    //   );
    // }

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
                "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
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
                "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${selectionTimeController.text + _selectedTimeStatus.toString()}",
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
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (imageFile != null)
              pw.ClipRRect(
                horizontalRadius: 12,
                verticalRadius: 12,
                child: pw.Image(
                  pw.MemoryImage(imageFile.readAsBytesSync()),
                  fit: pw.BoxFit.contain,
                  height: 200,
                ),
              ),
            if (description.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4,horizontal: 30),
                child: pw.Text(
                  description,
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
    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(20),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // ✅ पहले पेज पर full header, बाकी पर short header
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
                pw.UrlLink(
                  destination:
                      "https://drive.google.com/file/d/1P_2TqdiB-DCNpGdnzNHFniVyr3EPv0J5/view?usp=sharing",
                  child: pw.Container(
                    width: double.infinity,
                    height: 15,
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image:
                            pw.MemoryImage(offerLetterFooterProfileLinkImage),
                        fit: pw.BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),

                /// Full width divider
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
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: selectionTimeController,
                          labelText: "Selection Time",
                          hintText: "Selection Time",
                          inputFormatters: [
                            TimeTextInputFormatter(),
                          ],
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Expanded(
                        child: CommonDropDownWithoutSearch(
                          borderColor: PickColors.secondaryTextColor,
                          hintText: "AM / PM",
                          name: 'AM / PM',
                          items: GlobalList.timeStatus
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: CommonTextStyle()
                                          .textFieldTitleTextStyle,
                                    ),
                                  ))
                              .toList(),
                          isExpanded: false,
                          initialValue: _selectedTimeStatus,
                          onChanged: (newValue) {
                            setState(
                              () {
                                _selectedTimeStatus = newValue.toString();
                              },
                            );
                            debugPrint("----------$_selectedTimeStatus");
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
                          controller: description1Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
                        ),
                      ),
                      PickHeightAndWidth.width5,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: PickColors.textfieldBorderColor),
                        ),
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
                              });
                            }
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
                          controller: description2Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
                              });
                            }
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
                          controller: description5Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
                          controller: description6Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
                          controller: description7Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
                          controller: description8Controller,
                          labelText: "Description",
                          hintText: "Description",
                          maxLines: 3,
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
                        child: ImagePickerControl(
                          fieldName: "",
                          onFileChange: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.last != null) {
                              setState(() {
                                _images.add(File(value.last.path));
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
      );
    });
  }
}
