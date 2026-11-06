import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as ncp;
import 'package:flutter_native_contact_picker/model/contact.dart' as ncp;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:alekha/widget/pdf_bullet_text.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:alekha/screens/invoice_generator/invoice_provider/invoice_history_provider.dart';

class GstInvoiceGeneratorScreen extends StatefulWidget {
  const GstInvoiceGeneratorScreen({super.key});

  @override
  State<GstInvoiceGeneratorScreen> createState() =>
      _GstInvoiceGeneratorScreenState();
}

class _GstInvoiceGeneratorScreenState extends State<GstInvoiceGeneratorScreen> {
  String? _selectedOption;
  String? _selectedRegardsType;
  String? _selectedProjectCategory;
  bool isNewProject = false;
  bool isExistingProject = false;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController invoiceReferenceNoController = TextEditingController();
  TextEditingController projectNoController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  // Description, SAC, Price controllers for 8 rows
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sacController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController2 = TextEditingController();
  TextEditingController sacController2 = TextEditingController();
  TextEditingController priceController2 = TextEditingController();

  TextEditingController descriptionController3 = TextEditingController();
  TextEditingController sacController3 = TextEditingController();
  TextEditingController priceController3 = TextEditingController();

  TextEditingController descriptionController4 = TextEditingController();
  TextEditingController sacController4 = TextEditingController();
  TextEditingController priceController4 = TextEditingController();

  TextEditingController descriptionController5 = TextEditingController();
  TextEditingController sacController5 = TextEditingController();
  TextEditingController priceController5 = TextEditingController();

  TextEditingController descriptionController6 = TextEditingController();
  TextEditingController sacController6 = TextEditingController();
  TextEditingController priceController6 = TextEditingController();

  TextEditingController descriptionController7 = TextEditingController();
  TextEditingController sacController7 = TextEditingController();
  TextEditingController priceController7 = TextEditingController();

  TextEditingController descriptionController8 = TextEditingController();
  TextEditingController sacController8 = TextEditingController();
  TextEditingController priceController8 = TextEditingController();

  // GST rate controllers (default 9%)
  TextEditingController cgstRateController = TextEditingController();
  TextEditingController sgstRateController = TextEditingController();
  TextEditingController otherFirstGstRateController = TextEditingController();
  TextEditingController otherFirstGstNameController = TextEditingController();

  TextEditingController otherSecondGstRateController = TextEditingController();
  TextEditingController otherSecondGstNameController = TextEditingController();
  TextEditingController igstRateController = TextEditingController();

  double igstAmount = 0.0;
  double totalPrice = 0.0;
  double cgstAmount = 0.0;
  double sgstAmount = 0.0;

  double other1stGstAmount = 0.0;
  double other2ndGstAmount = 0.0;
  double grandTotal = 0.0;

  final ncp.FlutterNativeContactPicker _contactPicker =
      ncp.FlutterNativeContactPicker();

  @override
  void initState() {
    super.initState();
    priceController.addListener(calculateTotal);
    priceController2.addListener(calculateTotal);
    priceController3.addListener(calculateTotal);
    priceController4.addListener(calculateTotal);
    priceController5.addListener(calculateTotal);
    priceController6.addListener(calculateTotal);
    priceController7.addListener(calculateTotal);
    priceController8.addListener(calculateTotal);
    cgstRateController.addListener(calculateTotal);
    sgstRateController.addListener(calculateTotal);
    igstRateController.addListener(calculateTotal);
    otherFirstGstRateController.addListener(calculateTotal);
    otherFirstGstNameController.addListener(calculateTotal);
    otherSecondGstRateController.addListener(calculateTotal);
    otherSecondGstNameController.addListener(calculateTotal);
  }

  void calculateTotal() {
    double p1 = double.tryParse(priceController.text) ?? 0.0;
    double p2 = double.tryParse(priceController2.text) ?? 0.0;
    double p3 = double.tryParse(priceController3.text) ?? 0.0;
    double p4 = double.tryParse(priceController4.text) ?? 0.0;
    double p5 = double.tryParse(priceController5.text) ?? 0.0;
    double p6 = double.tryParse(priceController6.text) ?? 0.0;
    double p7 = double.tryParse(priceController7.text) ?? 0.0;
    double p8 = double.tryParse(priceController8.text) ?? 0.0;

    double subtotal = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8;
    double cgstRate = double.tryParse(cgstRateController.text) ?? 0.0;
    double sgstRate = double.tryParse(sgstRateController.text) ?? 0.0;
    double igstRate = double.tryParse(igstRateController.text) ?? 0.0;
    double other1stGstRate =
        double.tryParse(otherFirstGstRateController.text) ?? 0.0;
    double other2ndGstRate =
        double.tryParse(otherSecondGstRateController.text) ?? 0.0;

    double cgst = subtotal * cgstRate / 100;
    double sgst = subtotal * sgstRate / 100;
    double igst = subtotal * igstRate / 100;
    double other1stGst = subtotal * other1stGstRate / 100;
    double other2ndGst = subtotal * other2ndGstRate / 100;

    setState(() {
      totalPrice = subtotal;
      cgstAmount = cgst;
      sgstAmount = sgst;
      igstAmount = igst;
      other1stGstAmount = other1stGst;
      other2ndGstAmount = other2ndGst;
      grandTotal = subtotal + cgst + sgst + igst + other1stGst + other2ndGst;
    });
  }

  Future<void> _createPdf() async {
    Uint8List gstDesignStudioInvoiceImage =
        (await rootBundle.load(PickImages.gstDesignStudioInvoiceImage))
            .buffer
            .asUint8List();
    Uint8List gstContactInvoiceImage =
        (await rootBundle.load(PickImages.gstContactInvoiceImage))
            .buffer
            .asUint8List();
    Uint8List tusharSignatureImage =
        (await rootBundle.load(PickImages.tusharSignatureImage))
            .buffer
            .asUint8List();
    Uint8List ronakSignatureImage =
        (await rootBundle.load(PickImages.ronakSignatureImage))
            .buffer
            .asUint8List();
    Uint8List a4PdfBgImage =
        (await rootBundle.load(PickImages.a4PdfBgImage)).buffer.asUint8List();

    double cgstRate = double.tryParse(cgstRateController.text) ?? 0.0;
    double sgstRate = double.tryParse(sgstRateController.text) ?? 0.0;
    double igstRate = double.tryParse(igstRateController.text) ?? 0.0;
    double other1stGstRate =
        double.tryParse(otherFirstGstRateController.text) ?? 0.0;
    double other2ndGstRate =
        double.tryParse(otherSecondGstRateController.text) ?? 0.0;

    // Build dynamic item rows: [no, description, sac, amount]
    final List<List<String>> itemRows = [];

    void addRow(int no, TextEditingController desc, TextEditingController sac,
        double price) {
      if (desc.text.isNotEmpty || price != 0.0) {
        itemRows.add([
          no.toString().padLeft(2, '0'),
          desc.text,
          sac.text,
          price.toStringAsFixed(2),
        ]);
      }
    }

    addRow(1, descriptionController, sacController,
        double.tryParse(priceController.text) ?? 0.0);
    addRow(2, descriptionController2, sacController2,
        double.tryParse(priceController2.text) ?? 0.0);
    addRow(3, descriptionController3, sacController3,
        double.tryParse(priceController3.text) ?? 0.0);
    addRow(4, descriptionController4, sacController4,
        double.tryParse(priceController4.text) ?? 0.0);
    addRow(5, descriptionController5, sacController5,
        double.tryParse(priceController5.text) ?? 0.0);
    addRow(6, descriptionController6, sacController6,
        double.tryParse(priceController6.text) ?? 0.0);
    addRow(7, descriptionController7, sacController7,
        double.tryParse(priceController7.text) ?? 0.0);
    addRow(8, descriptionController8, sacController8,
        double.tryParse(priceController8.text) ?? 0.0);

    int grandTotalInt = grandTotal.toInt();
    String totalInWords = NumberToWord().convert('en-in', grandTotalInt) ?? '';
    String totalInWordsCap = totalInWords.isNotEmpty
        ? totalInWords[0].toUpperCase() + totalInWords.substring(1)
        : '';

    // ─── Helper: styled text ───────────────────────────────────────────────
    pw.TextStyle bold({double fontSize = 10}) =>
        pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize);
    pw.TextStyle normal({double fontSize = 10}) =>
        pw.TextStyle(fontSize: fontSize);

    // ─── Table header row ─────────────────────────────────────────────────
    pw.TableRow headerRow() => pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cell('NO.', style: bold()),
            _cell('DESCRIPTION', style: bold(), align: pw.Alignment.centerLeft),
            _cell('SAC/HSN', style: bold()),
            _cell('AMOUNT', style: bold()),
          ],
        );

    // ─── Item rows ────────────────────────────────────────────────────────
    List<pw.TableRow> dataRows = itemRows.map((row) {
      return pw.TableRow(
        children: [
          _cell(row[0]),
          _cell(row[1], align: pw.Alignment.centerLeft),
          _cell(row[2]),
          _cell(row[3], align: pw.Alignment.centerRight),
        ],
      );
    }).toList();

    // ─── CGST / SGST rows ─────────────────────────────────────────────────
    pw.TableRow gstRow(String label, double amount) => pw.TableRow(
          children: [
            _cell(''),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(label, style: normal()),
              ),
            ),
            _cell(''),
            _cell(amount.toStringAsFixed(2), align: pw.Alignment.centerRight),
          ],
        );

    // ─── Total row ────────────────────────────────────────────────────────
    pw.TableRow totalRow() => pw.TableRow(
          children: [
            _cell(''),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text('TOTAL', style: bold(fontSize: 11)),
            ),
            _cell(''),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(grandTotal.toStringAsFixed(2),
                    style: bold(fontSize: 11)),
              ),
            ),
          ],
        );

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              // decoration: pw.BoxDecoration(
              //   image: pw.DecorationImage(
              //     image: pw.MemoryImage(a4PdfBgImage),
              //     fit: pw.BoxFit.contain,
              //   ),
              // ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ── Logo row ──

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          width: 170,
                          height: 60,
                          margin: const pw.EdgeInsets.only(bottom: 2),
                          decoration: pw.BoxDecoration(
                            image: pw.DecorationImage(
                              image:
                                  pw.MemoryImage(gstDesignStudioInvoiceImage),
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 200,
                          height: 60,
                          decoration: pw.BoxDecoration(
                            image: pw.DecorationImage(
                              image: pw.MemoryImage(gstContactInvoiceImage),
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Divider(height: 3, color: PdfColor.fromHex("#616161")),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("TAX INVOICE",
                            style: pw.TextStyle(
                                fontSize: 13, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Date : ${dateController.text}",
                            style: pw.TextStyle(
                                fontSize: 13,
                                color: PdfColor.fromHex("#616161"))),
                      ],
                    ),
                    pw.Divider(height: 3, color: PdfColor.fromHex("#BDBDBD")),
                    pw.SizedBox(height: 5),
                    if (projectNoController.text.trim().isNotEmpty)
                      pw.Text("Project No. : ${projectNoController.text} "
                          "${_selectedProjectCategory == 'Architecture - A' ? 'A' : _selectedProjectCategory == 'Interior - I' ? 'I' : _selectedProjectCategory == 'Architecture Interior - AI' ? 'AI' : ''}"),
                    pw.Text(
                        "Invoice No. : ${invoiceNoController.text.toUpperCase()}"),
                    if (invoiceReferenceNoController.text.trim().isNotEmpty)
                      pw.Text(
                          "Invoice Reference No. : ${invoiceReferenceNoController.text}"),
                    pw.Text("For : "),
                    pw.Text(
                      "${clientNameController.text.toUpperCase()} - ${contactNoController.text}",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      addressController.text,
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 20),

                    // ── Main invoice table ──
                    pw.Table(
                      border: pw.TableBorder.all(),
                      // NO  | DESCRIPTION | SAC  | AMOUNT
                      columnWidths: {
                        0: const pw.FlexColumnWidth(0.4), // NO
                        1: const pw.FlexColumnWidth(3.0), // DESCRIPTION
                        2: const pw.FlexColumnWidth(0.6), // SAC
                        3: const pw.FlexColumnWidth(0.8), // AMOUNT
                      },
                      children: [
                        headerRow(),
                        ...dataRows,
                        // CGST row (only if rate > 0)
                        if (cgstRate > 0)
                          gstRow(
                              'CGST @ ${cgstRate % 1 == 0 ? cgstRate.toInt() : cgstRate}%',
                              cgstAmount),
                        // SGST row (only if rate > 0)
                        if (sgstRate > 0)
                          gstRow(
                              'SGST @ ${sgstRate % 1 == 0 ? sgstRate.toInt() : sgstRate}%',
                              sgstAmount),
                        if (igstRate > 0)
                          gstRow(
                              'IGST @ ${igstRate % 1 == 0 ? igstRate.toInt() : igstRate}%',
                              igstAmount),
                        if (other1stGstRate > 0)
                          gstRow(
                              '${otherFirstGstNameController.text} @ ${other1stGstRate % 1 == 0 ? other1stGstRate.toInt() : other1stGstRate}%',
                              other1stGstAmount),
                        if (other2ndGstRate > 0)
                          gstRow(
                              '${otherSecondGstNameController.text} @ ${other2ndGstRate % 1 == 0 ? other2ndGstRate.toInt() : other2ndGstRate}%',
                              other2ndGstAmount),
                        totalRow(),
                      ],
                    ),

                    // ── Amount in words ──
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      child: pw.Text(
                        '${totalInWordsCap}only',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),

                    pw.SizedBox(height: 20),
                    if (noteController.text.trim().isNotEmpty)
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Note : ",
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Expanded(
                            child: buildPdfBulletText(
                              noteController.text,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    pw.Spacer(),

                    // ── Signature + footer ──
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Align(
                            alignment: pw.Alignment.topRight,
                            child: pw.Text("ALEKHA DESIGN STUDIO LLP",
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Align(
                            alignment: pw.Alignment.topRight,
                            child: pw.Container(
                              width: 120,
                              height: 60,
                              decoration: pw.BoxDecoration(
                                image: pw.DecorationImage(
                                  image: pw.MemoryImage(
                                    _selectedRegardsType ==
                                            "Ar.Tushar Kachhadiya     "
                                        ? tusharSignatureImage
                                        : ronakSignatureImage,
                                  ),
                                  fit: pw.BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Align(
                            alignment: pw.Alignment.topRight,
                            child: pw.Text("Authorised Signatory",
                                style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "This is computer generated invoice doesn't required signature.",
                              style: pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColor.fromHex("#949494")),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 0.5)),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("BANK DETAILS :",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.SizedBox(height: 4),
                                      pw.Text(
                                          "A/C NAME - ALEKHA DESIGN STUDIO LLP"),
                                      pw.Text("BANK NAME - IDFC FIRST BANK"),
                                      pw.Text("A/C NO. - 10140439055"),
                                      pw.Text("IFS CODE - IDFB0042261"),
                                    ],
                                  ),
                                ),
                                pw.Container(
                                  width: 1,
                                  height: 70,
                                  color: PdfColors.grey,
                                  margin: const pw.EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("ALEKHA DESIGN STUDIO LLP",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.SizedBox(height: 4),
                                      pw.Text("PAN NO. - ACBFA7528C"),
                                      pw.Text("GSTIN - 24ACBFA7528C1ZU"),
                                      pw.Text(
                                          "LLP IDENTIFICATION NO. - ACA-7684"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 4),
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
                ),
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name:
          '${projectNoController.text} TAX INVOICE ${dateController.text.replaceAll('_', '/')} ${clientNameController.text.toUpperCase()}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    if (mounted) {
      await Provider.of<InvoiceHistoryProvider>(context, listen: false).recordInvoiceExport(
        clientName: clientNameController.text,
        invoiceNo: invoiceNoController.text,
        projectNo: projectNoController.text,
        contactNo: contactNoController.text,
        paymentStatus: _selectedOption == 'Fees Paid' ? 'Fees Paid' : (_selectedOption == 'Fees Unpaid' ? 'Fees Unpaid' : (_selectedOption ?? '')),
        totalAmount: grandTotal.toStringAsFixed(2),
        invoiceType: "GST Invoice",
      );
    }
  }

  /// Helper: returns a padded, centered cell
  pw.Widget _cell(
    String text, {
    pw.TextStyle? style,
    pw.Alignment align = pw.Alignment.center,
  }) {
    final defaultStyle = style ?? const pw.TextStyle(fontSize: 10);
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: buildPdfBulletText(
        text,
        style: defaultStyle,
        align: align,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String totalInWords = NumberToWord().convert('en-in', grandTotal.toInt());
    String totalInWordsCap = totalInWords.isNotEmpty
        ? totalInWords[0].toUpperCase() + totalInWords.substring(1)
        : '';

    return Consumer(
      builder: (context, GeneralHelper helper, snapshot) {
        return WillPopScope(
          onWillPop: () => helper.onWillPop(context),
          child: Scaffold(
            backgroundColor: PickColors.whiteColor,
            appBar: AppBar(
              backgroundColor: PickColors.whiteColor,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () => backToScreen(context: context),
                child: Icon(Icons.arrow_left_outlined,
                    size: 35, color: PickColors.hintColor),
              ),
              automaticallyImplyLeading: false,
              title:
                  Text('GST Invoice', style: CommonTextStyle().appBarTextStyle),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── New / Existing project checkboxes ──
                    Row(
                      children: [
                        Checkbox(
                          value: isNewProject,
                          onChanged: (v) {
                            setState(() {
                              isNewProject = v ?? false;
                              if (isNewProject) {
                                isExistingProject = false;
                                projectNoController.clear();
                                _selectedProjectCategory = null;
                              }
                            });
                          },
                        ),
                        const Text("New"),
                        const SizedBox(width: 20),
                        Checkbox(
                          value: isExistingProject,
                          onChanged: (v) {
                            setState(() {
                              isExistingProject = v ?? false;
                              if (isExistingProject) {
                                isNewProject = false;
                              } else {
                                projectNoController.clear();
                                _selectedProjectCategory = null;
                              }
                            });
                          },
                        ),
                        const Text("Existing"),
                      ],
                    ),
                    PickHeightAndWidth.height20,

                    // ── Date ──
                    CommonTextFieldWithBorder(
                      fillColor: Colors.transparent,
                      filled: true,
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.calendar_month_outlined,
                            color: PickColors.primaryColor),
                      ),
                      isRequired: true,
                      readOnly: true,
                      hint: "Date",
                      controller: dateController,
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.none,
                      validator: (_) => null,
                      onTap: () async {
                        DateTime? pickedDate = await getDateFunction(
                            isOldDate: true, context: context);
                        if (pickedDate != null) {
                          dateController.text =
                              DateFormate.normalDateFormate.format(pickedDate);
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 20),

                    // ── Existing project fields ──
                    if (isExistingProject) ...[
                      CommonTextFieldWithFocus(
                        controller: projectNoController,
                        labelText: "Project No.",
                        hintText: "Project No.",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      CommonDropDownWithoutSearch(
                        borderColor: PickColors.primaryColor,
                        hintText: "Select project category",
                        name: 'Project Category',
                        items: GlobalList.projectCategory
                            .map((c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(c,
                                      style: CommonTextStyle()
                                          .textFieldTitleTextStyle),
                                ))
                            .toList(),
                        isExpanded: false,
                        initialValue: _selectedProjectCategory,
                        onChanged: (v) => setState(
                            () => _selectedProjectCategory = v.toString()),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Invoice details ──
                    CommonTextFieldWithFocus(
                      controller: invoiceNoController,
                      labelText: "Invoice No.",
                      hintText: "Invoice No.",
                    ),
                    const SizedBox(height: 20),
                    CommonTextFieldWithFocus(
                      controller: invoiceReferenceNoController,
                      labelText: "Invoice Reference No.",
                      hintText: "Invoice Reference No.",
                    ),
                    const SizedBox(height: 20),
                    CommonTextFieldWithFocus(
                      controller: clientNameController,
                      labelText: "Client Name",
                      hintText: "Client Name",
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    CommonTextFieldWithFocus(
                      controller: contactNoController,
                      labelText: "Contact No.",
                      hintText: "Contact No.",
                      suffixIcon: InkWell(
                        onTap: () => helper.pickContact(contactNoController),
                        child: const Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),
                    CommonTextFieldWithFocus(
                      controller: addressController,
                      labelText: "Address",
                      hintText: "Address",
                    ),
                    const SizedBox(height: 20),

                    // ── Line items (Description | SAC | Amount) ──
                    const Text("Line Items",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    _buildLineItemRow(
                        descriptionController, sacController, priceController),
                    _buildLineItemRow(descriptionController2, sacController2,
                        priceController2),
                    _buildLineItemRow(descriptionController3, sacController3,
                        priceController3),
                    _buildLineItemRow(descriptionController4, sacController4,
                        priceController4),
                    _buildLineItemRow(descriptionController5, sacController5,
                        priceController5),
                    _buildLineItemRow(descriptionController6, sacController6,
                        priceController6),
                    _buildLineItemRow(descriptionController7, sacController7,
                        priceController7),
                    _buildLineItemRow(descriptionController8, sacController8,
                        priceController8),

                    const SizedBox(height: 20),

                    // ── GST rates ──
                    const Text("GST Rates (%)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: cgstRateController,
                            labelText: "CGST %",
                            hintText: "CGST %",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: sgstRateController,
                            labelText: "SGST %",
                            hintText: "SGST %",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                         Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: igstRateController,
                            labelText: "IGST %",
                            hintText: "IGST %",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: otherFirstGstNameController,
                            labelText: "Other",
                            hintText: "Other",
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: otherFirstGstRateController,
                            labelText: "Other %",
                            hintText: "Other %",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: otherSecondGstNameController,
                            labelText: "Other",
                            hintText: "Other",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonTextFieldWithFocus(
                            controller: otherSecondGstRateController,
                            labelText: "Other %",
                            hintText: "Other %",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Live totals preview ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _summaryRow(
                              "Subtotal", "₹${totalPrice.toStringAsFixed(2)}"),
                          if (cgstAmount > 0)
                            _summaryRow("CGST @ ${cgstRateController.text}%",
                                "₹${cgstAmount.toStringAsFixed(2)}"),
                          if (sgstAmount > 0)
                            _summaryRow("SGST @ ${sgstRateController.text}%",
                                "₹${sgstAmount.toStringAsFixed(2)}"),
                          if (igstAmount > 0)
                            _summaryRow("IGST @ ${igstRateController.text}%",
                                "₹${igstAmount.toStringAsFixed(2)}"),
                          if (other1stGstAmount > 0)
                            _summaryRow(
                                "${otherFirstGstNameController.text} ${otherFirstGstRateController.text}%",
                                "₹${other1stGstAmount.toStringAsFixed(2)}"),
                          if (other2ndGstAmount > 0)
                            _summaryRow(
                                "${otherSecondGstNameController.text} ${otherSecondGstRateController.text}%",
                                "₹${other2ndGstAmount.toStringAsFixed(2)}"),
                          const Divider(),
                          _summaryRow(
                            "Grand Total",
                            "₹${grandTotal.toStringAsFixed(2)}",
                            bold: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${totalInWordsCap}only",
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Regards ──
                    CommonDropDownWithoutSearch(
                      borderColor: PickColors.primaryColor,
                      hintText: "Regards",
                      name: 'Regards',
                      items: GlobalList.regardsName
                          .map((c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c,
                                    style: CommonTextStyle()
                                        .textFieldTitleTextStyle),
                              ))
                          .toList(),
                      isExpanded: false,
                      initialValue: _selectedRegardsType,
                      onChanged: (v) =>
                          setState(() => _selectedRegardsType = v.toString()),
                    ),
                    const SizedBox(height: 20),

                    // ── Fees status radio ──
                    Row(
                      children: GlobalList.feesStatusOptions.map((option) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: option,
                              groupValue: _selectedOption,
                              onChanged: (v) =>
                                  setState(() => _selectedOption = v),
                            ),
                            Text(option,
                                style:
                                    CommonTextStyle().textFieldTitleTextStyle),
                            PickHeightAndWidth.width20,
                          ],
                        );
                      }).toList(),
                    ),
                    PickHeightAndWidth.height20,

                    // ── Note ──
                    CommonTextFieldWithFocus(
                      controller: noteController,
                      labelText: "Note",
                      hintText: "Note",
                      maxLines: 2,
                    ),
                    PickHeightAndWidth.height20,

                    // ── Bank detail box ──

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: PickColors.switchOffColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("BANK DETAILS :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                SizedBox(height: 4),
                                Text("A/C NAME - ALEKHA DESIGN STUDIO LLP",
                                    style: TextStyle(fontSize: 10)),
                                Text("BANK NAME - IDFC FIRST BANK",
                                    style: TextStyle(fontSize: 10)),
                                Text("A/C NO. - 10140439055",
                                    style: TextStyle(fontSize: 10)),
                                Text("IFS CODE - IDFB0042261",
                                    style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 80,
                            color: PickColors.hintColor,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ALEKHA DESIGN STUDIO LLP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                SizedBox(height: 4),
                                Text("PAN NO. - ACBFA7528C",
                                    style: TextStyle(fontSize: 10)),
                                Text("GSTIN - 24ACBFA7528C1ZU",
                                    style: TextStyle(fontSize: 10)),
                                Text("LLP IDENTIFICATION NO. - ACA-7684",
                                    style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.all(0),
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     border:
                    //         Border.all(color: PickColors.textfieldBorderColor),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Text(
                    //     "A/c Name : Alekha Architects\n Bank Name : Surat National Co.Op. Bank\n A/c No. : 008 1201 0000 4535\n IFS Code : SUNB0000008",
                    //     style: CommonTextStyle()
                    //         .hintTextStyle
                    //         .copyWith(fontSize: 8),
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    // ── Action buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: CommonMaterialButton(
                            title: "Export as Pdf",
                            suffixIcon: PickImages.pdfIcon,
                            onPressed: () async {
                              await _createPdf();
                              showToast(message: 'PDF generated successfully!', isPositive: true, context: context);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonMaterialButton(
                            title: "Share",
                            suffixIcon: PickImages.whatsAppIcon,
                            style: CommonTextStyle().buttonTextStyle,
                            color: PickColors.successColor,
                            onPressed: () async {
                              await helper.shareViaWhatsApp(context);
                            },
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
      },
    );
  }

  /// Builds one line-item row: Description (flex 3) | SAC (flex 1) | Amount (flex 1)
  Widget _buildLineItemRow(
    TextEditingController descCtrl,
    TextEditingController sacCtrl,
    TextEditingController priceCtrl,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: CommonTextFieldWithFocus(
              controller: descCtrl,
              labelText: "Description",
              hintText: "Description",
              maxLines: 2,
            ),
          ),
          PickHeightAndWidth.width5,
          Expanded(
            child: CommonTextFieldWithFocus(
              controller: sacCtrl,
              labelText: "SAC/HSN",
              hintText: "SAC/HSN",
              keyboardType: TextInputType.number,
            ),
          ),
          PickHeightAndWidth.width5,
          Expanded(
            child: CommonTextFieldWithFocus(
              controller: priceCtrl,
              labelText: "Amount",
              hintText: "Amount",
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  /// Summary row widget for the totals preview card
  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 14 : 13,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
