import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceGeneratorScreen extends StatefulWidget {
  const InvoiceGeneratorScreen({super.key});

  @override
  State<InvoiceGeneratorScreen> createState() => _InvoiceGeneratorScreenState();
}

class _InvoiceGeneratorScreenState extends State<InvoiceGeneratorScreen> {
  String? _selectedRegardsType;
  String? _selectedProjectCategory;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController invoiceRferenceNoController = TextEditingController();

  TextEditingController invoiceReferenceNoController = TextEditingController();
  TextEditingController projectNoController = TextEditingController();
  TextEditingController bankDetailController = TextEditingController();

  // Controllers for text fields
  TextEditingController descriptionController2 = TextEditingController();
  TextEditingController priceController2 = TextEditingController();
  TextEditingController descriptionController3 = TextEditingController();
  TextEditingController priceController3 = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController4 = TextEditingController();
  TextEditingController priceController4 = TextEditingController();
  TextEditingController descriptionController5 = TextEditingController();
  TextEditingController priceController5 = TextEditingController();
  TextEditingController descriptionController6 = TextEditingController();
  TextEditingController priceController6 = TextEditingController();
  TextEditingController descriptionController7 = TextEditingController();
  TextEditingController priceController7 = TextEditingController();
  TextEditingController descriptionController8 = TextEditingController();
  TextEditingController priceController8 = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Create a PDF document
  Future<void> _createPdf() async {
    Uint8List imageData =
        (await rootBundle.load(PickImages.invoicePdfLogo)).buffer.asUint8List();
    Uint8List invoiceContactPdfLogo =
        (await rootBundle.load(PickImages.invoiceContactPdfLogo))
            .buffer
            .asUint8List();

    // Parse prices to double for calculations
    double price1 = double.tryParse(priceController.text) ?? 0.0;
    double price2 = double.tryParse(priceController2.text) ?? 0.0;
    double price3 = double.tryParse(priceController3.text) ?? 0.0;
    double price4 = double.tryParse(priceController4.text) ?? 0.0;
    double price5 = double.tryParse(priceController5.text) ?? 0.0;
    double price6 = double.tryParse(priceController6.text) ?? 0.0;
    double price7 = double.tryParse(priceController7.text) ?? 0.0;
    double price8 = double.tryParse(priceController8.text) ?? 0.0;

    // Calculate total price
    double totalPrice =
        price1 + price2 + price3 + price4 + price5 + price6 + price7 + price8;

    // Dynamically build table rows
    final List<List<String>> tableData = [];

    if (descriptionController.text.isNotEmpty || price1 != 0.0) {
      tableData
          .add(['1', descriptionController.text, price1.toStringAsFixed(2)]);
    }
    if (descriptionController2.text.isNotEmpty || price2 != 0.0) {
      tableData
          .add(['2', descriptionController2.text, price2.toStringAsFixed(2)]);
    }
    if (descriptionController3.text.isNotEmpty || price3 != 0.0) {
      tableData
          .add(['3', descriptionController3.text, price3.toStringAsFixed(2)]);
    }
    if (descriptionController4.text.isNotEmpty || price4 != 0.0) {
      tableData
          .add(['4', descriptionController4.text, price4.toStringAsFixed(2)]);
    }
    if (descriptionController5.text.isNotEmpty || price5 != 0.0) {
      tableData
          .add(['5', descriptionController5.text, price5.toStringAsFixed(2)]);
    }
    if (descriptionController6.text.isNotEmpty || price6 != 0.0) {
      tableData
          .add(['6', descriptionController6.text, price6.toStringAsFixed(2)]);
    }
    if (descriptionController7.text.isNotEmpty || price7 != 0.0) {
      tableData
          .add(['7', descriptionController7.text, price7.toStringAsFixed(2)]);
    }
    if (descriptionController8.text.isNotEmpty || price8 != 0.0) {
      tableData
          .add(['8', descriptionController8.text, price8.toStringAsFixed(2)]);
    }

    if (tableData.isNotEmpty) {
      tableData.add(['Total'.toUpperCase(), '', totalPrice.toStringAsFixed(2)]);
    }

    final pdf = pw.Document();

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
              pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("INVOICE",
                      style: pw.TextStyle(
                          fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Date : ${dateController.text}",
                      style: pw.TextStyle(
                          fontSize: 13, color: PdfColor.fromHex("#616161"))),
                ],
              ),
              pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
              pw.SizedBox(height: 5),
              pw.Text(
                  "Project No. : ${projectNoController.text} ${_selectedProjectCategory == 'Architecture - A' ? 'A' : _selectedProjectCategory == 'Interior - I' ? 'I' : _selectedProjectCategory == 'Architecture Interior - AI' ? 'AI' : ''}"
                  // $_selectedProjectCategory",
                  ),
              pw.Text(
                  "Invoice No. : ${invoiceNoController.text.toUpperCase()}"),
              pw.Text(
                  "Invoice Reference No. : ${invoiceReferenceNoController.text}"),
              pw.Text("For : "),
              pw.Text(
                "${clientNameController.text.toUpperCase()} - ${contactNoController.text}",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                addressController.text,
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              // pw.Table(
              //   border: pw.TableBorder.all(),
              //   columnWidths: {
              //     0: const pw.FlexColumnWidth(0.5),
              //     1: const pw.FlexColumnWidth(3),
              //     2: const pw.FlexColumnWidth(0.7),
              //   },
              //   children: [
              //     // Header Row
              //     pw.TableRow(
              //       decoration:
              //           const pw.BoxDecoration(color: PdfColors.grey300),
              //       children: [
              //         pw.Padding(
              //           padding: const pw.EdgeInsets.all(4),
              //           child: pw.Center(
              //             child: pw.Text('No.'.toUpperCase(),
              //                 style:
              //                     pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              //           ),
              //         ),
              //         pw.Padding(
              //           padding: const pw.EdgeInsets.all(4),
              //           child: pw.Text('Description'.toUpperCase(),
              //               style:
              //                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              //         ),
              //         pw.Padding(
              //           padding: const pw.EdgeInsets.all(4),
              //           child: pw.Text('Amount'.toUpperCase(),
              //               style:
              //                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              //         ),
              //       ],
              //     ),

              //     // Data Rows
              //     ...tableData.map(
              //       (row) {
              //         final isTotalRow = row[0].toUpperCase() == 'TOTAL';
              //         const defaultTextStyle = pw.TextStyle();
              //         final boldTextStyle = pw.TextStyle(
              //           fontWeight: pw.FontWeight.bold,
              //           fontSize: 1,
              //         );
              //         final totalAmountStyle = pw.TextStyle(
              //           fontWeight: pw.FontWeight.bold,
              //           fontSize: 12, // <- Increased font size for amount only
              //         );

              //         return pw.TableRow(
              //           children: [
              //             pw.Padding(
              //               padding: const pw.EdgeInsets.all(4),
              //               child: pw.Center(
              //                 child: pw.Text(row[0],
              //                     style: isTotalRow
              //                         ? boldTextStyle
              //                         : defaultTextStyle),

              //               ),
              //             ),
              //             pw.Padding(
              //               padding: const pw.EdgeInsets.all(4),
              //               child: pw.Align(
              //                 alignment: pw.Alignment.centerLeft,
              //                 child: pw.Text(row[1],
              //                     style: isTotalRow
              //                         ? boldTextStyle
              //                         : defaultTextStyle),
              //               ),
              //             ),
              //             pw.Padding(
              //               padding: const pw.EdgeInsets.all(4),
              //               child: pw.Align(
              //                 alignment: pw.Alignment.centerLeft,
              //                 child: pw.Text(
              //                   row[2],
              //                   style: isTotalRow
              //                       ? totalAmountStyle
              //                       : defaultTextStyle,
              //                 ),
              //               ),
              //             ),

              //           ],
              //         );
              //       },
              //     ),
              //   ],
              // ),

              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(0.5),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(0.7),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Center(
                          child: pw.Text('No.'.toUpperCase(),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('Description'.toUpperCase(),
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('Amount'.toUpperCase(),
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),

                  // Data Rows
                  ...tableData.map(
                    (row) {
                      final isTotalRow = row[0].toUpperCase() == 'TOTAL';
                      const defaultTextStyle = pw.TextStyle();
                      final boldTextStyle = pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      );
                      final totalAmountStyle = pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12, // <- Increased font size for amount only
                      );

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(row[0],
                                  style: isTotalRow
                                      ? boldTextStyle
                                      : defaultTextStyle),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Align(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(row[1],
                                  style: isTotalRow
                                      ? boldTextStyle
                                      : defaultTextStyle),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Align(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                row[2],
                                style: isTotalRow
                                    ? totalAmountStyle
                                    : defaultTextStyle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Row for Amount in Words, spanning all columns
                  // pw.TableRow(
                  //   children: [
                  //     pw.Padding(
                  //       padding: const pw.EdgeInsets.all(4),
                  //       child: pw.Text(
                  //         'Amount in Words: ${amountController.text}', // Assuming you have a function to convert the number to words
                  //         style: pw.TextStyle(
                  //             fontWeight: pw.FontWeight.bold, fontSize: 12),
                  //         textAlign: pw.TextAlign.center,
                  //       ),
                  //     ),
                  //     pw.Container(),
                  //     pw.Container(),
                  //   ],
                  // ),
                  // "Amount in Words" row (span across the full width of the table)

                  // pw.TableRow(
                  //   children: [
                  //     // We create a single cell that spans the full width
                  //     pw.Expanded(
                  //       flex: 4,
                  //       child: pw.Padding(
                  //         padding: const pw.EdgeInsets.all(4),
                  //         child: pw.Text(
                  //           'Amount in Words: ${amountController.text}',
                  //           style: pw.TextStyle(
                  //               fontWeight: pw.FontWeight.bold, fontSize: 12),
                  //           textAlign: pw.TextAlign.center,
                  //         ),
                  //       ),
                  //     ),

                  //     // Empty cells to fill in for other columns
                  //     pw.Expanded(
                  //       child: pw.Container(),
                  //     ),

                  //     pw.Expanded(
                  //       child: pw.Container(),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              pw.Container(
                padding: pw.EdgeInsets.all(5.00),
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.only(
                    bottomRight: pw.Radius.circular(0),
                    bottomLeft: pw.Radius.circular(0),
                  ),
                  border: pw.Border.all(
                    width: 1,
                  ),
                ),
                child: pw.Text(
                  "${amountController.text}",
                  textAlign: pw.TextAlign.center,
                ),
              ),

              pw.Spacer(),
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.topRight,
                      child: pw.Text("ALEKHA ARCHITECTS",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Align(
                      alignment: pw.Alignment.topRight,
                      child: pw.Text(_selectedRegardsType.toString(),
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "This is computer generated invoice doesn't required signature.",
                        style: pw.TextStyle(
                            fontSize: 11, color: PdfColor.fromHex("#949494")),
                      ),
                    ),
                    pw.Divider(color: PdfColor.fromHex("#616161")),
                    pw.Text("BANK DETAILS :"),
                    pw.Text("A/C NAME - ALEKHA ARCHITECTS"),
                    pw.Text("BANK NAME - SURAT NATIONAL CO. OP. BANK"),
                    pw.Text("A/C NO. - 008120100004535"),
                    pw.Text("IFS CODE - SUNB0000008"),
                    pw.Divider(color: PdfColor.fromHex("#616161")),
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "G.F. Plot No.29, Hira Nagar, Bamroll Road, Nr.Saraswati Hindi Vidyalaya, Surat, Gujarat.",
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name:
          '${projectNoController.text} INVOICE ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Invoice"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                    dateController.text = formattedDate; // Set the picked date
                  }
                },
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: projectNoController,
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
              CommonTextFieldWithFocus(
                controller: invoiceNoController,
                labelText: "Invoice No.",
                hintText: "Invoice No.",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: invoiceReferenceNoController,
                labelText: "Invoice Reference No.",
                hintText: "Invoice Reference No.",
              ),
              const SizedBox(
                height: 20,
              ),
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // Max 10 digits
                  FilteringTextInputFormatter.digitsOnly, // Only digits
                ],
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
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController,
                      labelText: "Amount in words",
                      keyboardType: TextInputType.number,
                      hintText: "Amount in words",
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController2,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController2,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController3,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController3,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController4,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController4,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController5,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController5,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController6,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController6,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController7,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController7,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
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
                    flex: 2,
                    child: CommonTextFieldWithFocus(
                      controller: descriptionController8,
                      labelText: " Description",
                      hintText: "Description",
                      maxLines: 2,
                    ),
                  ),
                  PickHeightAndWidth.width5,
                  Expanded(
                    child: CommonTextFieldWithFocus(
                      controller: priceController8,
                      labelText: "Amount",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: amountController,
                labelText: "Amount",
                hintText: "Amount",
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonDropDownWithoutSearch(
                borderColor: PickColors.primaryColor,
                hintText: "Regards",
                name: 'Regards',
                items: GlobalList.regardsName
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: CommonTextStyle().textFieldTitleTextStyle,
                          ),
                        ))
                    .toList(),
                isExpanded: false,
                initialValue: _selectedRegardsType,
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedRegardsType = newValue.toString();
                    },
                  );
                  debugPrint("----------$_selectedRegardsType");
                },
              ),
              const SizedBox(height: 20),
              // Comm
              Container(
                margin: EdgeInsets.all(0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: PickColors.textfieldBorderColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "A/c Name : Alekha Architects\n Bank Name : Surat National Co.Op. Bank\n A/c No. : 008 1201 0000 4535\n IFS Code : SUNB0000008",
                  style: CommonTextStyle().hintTextStyle.copyWith(fontSize: 8),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _createPdf();

                  // Show snackbar after successful PDF generation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PDF generated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Generate PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
