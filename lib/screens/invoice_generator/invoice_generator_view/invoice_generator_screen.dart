// // import 'package:alekha/constant/colors.dart';
// // import 'package:alekha/constant/navigation_route.dart';
// // import 'package:alekha/constant/text_style.dart';
// // import 'package:alekha/widget/common_dropdown.dart';
// // import 'package:alekha/widget/common_material_button.dart';
// // import 'package:alekha/widget/common_text_field.dart';
// // import 'package:flutter/material.dart';

// // class InvoiceGeneratorScreen extends StatefulWidget {
// //   const InvoiceGeneratorScreen({super.key});

// //   @override
// //   State<InvoiceGeneratorScreen> createState() => _InvoiceGeneratorScreenState();
// // }

// // class _InvoiceGeneratorScreenState extends State<InvoiceGeneratorScreen> {
// //   TextEditingController clientNameController = TextEditingController();
// //   TextEditingController projectNumberController = TextEditingController();
// //   TextEditingController siteVisitNumber = TextEditingController();
// //   TextEditingController dateController = TextEditingController();
// //   TextEditingController workStageOnSiteController = TextEditingController();
// //   TextEditingController decisionController = TextEditingController();
// //   TextEditingController decisionPendingController = TextEditingController();
// //   TextEditingController changesOnSiteController = TextEditingController();
// //   TextEditingController nextOnSiteController = TextEditingController();
// //   List<String> projectCategory = ["A", "I", "AI"];
// //   String? _selectedProjectCategory;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: PickColors.blackColor,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         centerTitle: true,
// //         leading: GestureDetector(
// //           onTap: () {
// //             backToScreen(context: context);
// //           },
// //           child: const Icon(
// //             Icons.arrow_left_outlined,
// //             color: PickColors.whiteColor,
// //           ),
// //         ),
// //         automaticallyImplyLeading: false,
// //         title: const Text(
// //           'Invoice Generator',
// //           style: CommonTextStyle.mainHeadingTextStyle,
// //         ),
// //       ),

// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               CommonTextFieldWithFocus(
// //                 controller: clientNameController,
// //                 labelText: "Client Name",
// //                 hintText: "Client Name",
// //                 keyboardType: TextInputType.name,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: projectNumberController,
// //                 labelText: "Project No.",
// //                 hintText: "Project No.",
// //                 keyboardType: TextInputType.number,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonDropDownWithoutSearch(
// //                 borderColor: PickColors.whiteColor,
// //                 hintText: "Select project category",
// //                 name: 'Project Category',
// //                 items: projectCategory
// //                     .map((category) => DropdownMenuItem<String>(
// //                           value: category,
// //                           child: Text(
// //                             category,
// //                             style: const TextStyle(
// //                                 fontSize: 15, fontWeight: FontWeight.w400),
// //                           ),
// //                         ))
// //                     .toList(),
// //                 isExpanded: false,
// //                 initialValue: _selectedProjectCategory,
// //                 onChanged: (newValue) {
// //                   setState(
// //                     () {
// //                       _selectedProjectCategory = newValue.toString();
// //                     },
// //                   );
// //                   debugPrint("----------$_selectedProjectCategory");
// //                 },
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: workStageOnSiteController,
// //                 labelText: "Work Stage on Site",
// //                 hintText: "Work Stage on Site",
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: decisionController,
// //                 labelText: "Decisions",
// //                 hintText: "Decisions",
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: decisionPendingController,
// //                 labelText: "Decisions pending",
// //                 hintText: "Decisions pending",
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: changesOnSiteController,
// //                 labelText: "Changes on site",
// //                 hintText: "Changes on site",
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               CommonTextFieldWithFocus(
// //                 controller: nextOnSiteController,
// //                 labelText: "Next on site",
// //                 hintText: "Next on site",
// //                 maxLines: 2,
// //               ),
// //               // const SizedBox(height: 10),

// //               const SizedBox(height: 20),
// //               CommonMaterialButton(
// //                 title: 'Create PDF',
// //                 onPressed: () {},
// //                 // onPressed: _generatePDF,
// //                 // color: Colors.black,
// //                 verticalPadding: 20,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:path_provider/path_provider.dart';

// class InvoiceGeneratorScreen extends StatefulWidget {
//   const InvoiceGeneratorScreen({super.key});

//   @override
//   State<InvoiceGeneratorScreen> createState() => _InvoiceGeneratorScreenState();
// }

// class _InvoiceGeneratorScreenState extends State<InvoiceGeneratorScreen> {
//   TextEditingController clientNameController = TextEditingController();
//   TextEditingController projectNumberController = TextEditingController();
//   TextEditingController workStageOnSiteController = TextEditingController();
//   TextEditingController decisionController = TextEditingController();
//   TextEditingController decisionPendingController = TextEditingController();
//   TextEditingController changesOnSiteController = TextEditingController();
//   TextEditingController nextOnSiteController = TextEditingController();
//   List<String> projectCategory = ["A", "I", "AI"];
//   String? _selectedProjectCategory;

//   // Function to create and save PDF
//   Future<void> _generatePDF() async {
//     // Create a new PDF document
//     PdfDocument document = PdfDocument();

//     // Add a page to the document
//     final PdfPage page = document.pages.add();

//     // Create a table
//     PdfGrid grid = PdfGrid();

//     // Add columns to the table
//     grid.columns.add(count: 2);

//     // Add headers to the table
//     grid.headers.add(1);
//     PdfGridRow header = grid.headers[0];
//     header.cells[0].value = 'Field';
//     header.cells[1].value = 'Value';

//     // Add rows with data
//     _addRow(grid, 'Client Name', clientNameController.text);
//     _addRow(grid, 'Project No.', projectNumberController.text);
//     _addRow(grid, 'Project Category', _selectedProjectCategory ?? '');
//     _addRow(grid, 'Work Stage on Site', workStageOnSiteController.text);
//     _addRow(grid, 'Decisions', decisionController.text);
//     _addRow(grid, 'Decisions Pending', decisionPendingController.text);
//     _addRow(grid, 'Changes on Site', changesOnSiteController.text);
//     _addRow(grid, 'Next on Site', nextOnSiteController.text);

//     // Set table style
//     grid.style = PdfGridStyle(
//       cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
//       font: PdfStandardFont(PdfFontFamily.helvetica, 12),
//       backgroundBrush: PdfBrushes.lightGray,
//     );

//     // Draw the grid on the page
//     grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));

//     // Save the PDF document
//     List<int> bytes = document.saveSync();
//     document.dispose();

//     // Get the device's directory to save the file
//     Directory? directory = await getApplicationDocumentsDirectory();
//     String path = directory.path;
//     File file = File('$path/Invoice.pdf');
//     await file.writeAsBytes(bytes, flush: true);

//     // Optionally, you can display a message or share the PDF here
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("PDF saved at $path/Invoice.pdf"),
//     ));
//   }

//   // Helper method to add rows to the PDF table
//   void _addRow(PdfGrid grid, String field, String value) {
//     PdfGridRow row = grid.rows.add();
//     row.cells[0].value = field;
//     row.cells[1].value = value.isNotEmpty ? value : '-';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_left_outlined,
//             color: Colors.white,
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Invoice Generator',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: clientNameController,
//                 decoration: InputDecoration(
//                   labelText: "Client Name",
//                   hintText: "Client Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: projectNumberController,
//                 decoration: InputDecoration(
//                   labelText: "Project No.",
//                   hintText: "Project No.",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedProjectCategory,
//                 hint: const Text("Select project category"),
//                 items: projectCategory.map((category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedProjectCategory = newValue;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: workStageOnSiteController,
//                 decoration: InputDecoration(
//                   labelText: "Work Stage on Site",
//                   hintText: "Work Stage on Site",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: decisionController,
//                 decoration: InputDecoration(
//                   labelText: "Decisions",
//                   hintText: "Decisions",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: decisionPendingController,
//                 decoration: InputDecoration(
//                   labelText: "Decisions Pending",
//                   hintText: "Decisions Pending",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: changesOnSiteController,
//                 decoration: InputDecoration(
//                   labelText: "Changes on Site",
//                   hintText: "Changes on Site",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: nextOnSiteController,
//                 decoration: InputDecoration(
//                   labelText: "Next on Site",
//                   hintText: "Next on Site",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _generatePDF,
//                 child: const Text("Create PDF"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceGeneratorScreen extends StatefulWidget {
  const InvoiceGeneratorScreen({super.key});

  @override
  State<InvoiceGeneratorScreen> createState() => _InvoiceGeneratorScreenState();
}

class _InvoiceGeneratorScreenState extends State<InvoiceGeneratorScreen> {
  // Controllers for text fields
  TextEditingController descriptionController2 = TextEditingController();
  TextEditingController priceController2 = TextEditingController();
  TextEditingController descriptionController3 = TextEditingController();
  TextEditingController priceController3 = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // Create a PDF document
  Future<void> _createPdf() async {
    // Parse prices to double for calculations
    double price1 = double.tryParse(priceController.text) ?? 0.0;
    double price2 = double.tryParse(priceController2.text) ?? 0.0;
    double price3 = double.tryParse(priceController3.text) ?? 0.0;

    // Calculate total price
    double totalPrice = price1 + price2 + price3;

    // Create a PDF document
    final pdf = pw.Document();

    // Define a table with 3 columns, including the "Total" row
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('PDF Table Example'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['No.', 'Description', 'Price'],
                data: [
                  [
                    '1',
                    descriptionController.text,
                    (price1.toStringAsFixed(2))
                  ],
                  [
                    '2',
                    descriptionController2.text,
                    (price2.toStringAsFixed(2))
                  ],
                  [
                    '3',
                    descriptionController3.text,
                    (price3.toStringAsFixed(2))
                  ],
                  // Total row
                  ['Total', '', (totalPrice.toStringAsFixed(2))]
                ],
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 12),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1), // First column width (No.)
                  1: const pw.FlexColumnWidth(
                      3), // Second column width (Description)
                  2: const pw.FlexColumnWidth(2), // Third column width (Price)
                },
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF or show preview
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PDF View"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: "Enter Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(hintText: "Enter Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController2,
              decoration: const InputDecoration(hintText: "Enter Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController2,
              decoration: const InputDecoration(hintText: "Enter Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController3,
              decoration: const InputDecoration(hintText: "Enter Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController3,
              decoration: const InputDecoration(hintText: "Enter Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPdf,
              child: const Text("Generate PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
