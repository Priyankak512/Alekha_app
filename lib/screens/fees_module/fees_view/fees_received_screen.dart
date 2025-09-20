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
import 'package:provider/provider.dart';

class FeesReceivedScreen extends StatefulWidget {
  const FeesReceivedScreen({super.key});

  @override
  State<FeesReceivedScreen> createState() => _FeesReceivedScreenState();
}

class _FeesReceivedScreenState extends State<FeesReceivedScreen> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController projectNoController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController feesSummeryController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController();

  String? _selectedRegardsType;
  String? _paymentMode;

  bool _showPreviewMessage = false; // Visibility flag for the message
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
              'Fees Received',
              style: CommonTextStyle().appBarTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CommonTextFieldWithFocus(
                    controller: clientNameController,
                    labelText: "Client Name",
                    hintText: "Client Name",
                    keyboardType: TextInputType.name,
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: projectNoController,
                          labelText: "Project No.",
                          hintText: "Project No.",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      PickHeightAndWidth.width10,
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: feesController,
                          labelText: "Fees Stage",
                          hintText: "Fees Stage",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithBorder(
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
                              String formattedDate = DateFormate
                                  .normalDateFormate
                                  .format(pickedDate);
                              dateMeetingController.text =
                                  formattedDate; // Set the picked date
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      PickHeightAndWidth.width10,
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: invoiceNoController,
                          labelText: "Invoice No.",
                          hintText: "Invoice No.",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFieldWithFocus(
                          controller: amountReceivedController,
                          labelText: "Amount Received",
                          hintText: "Amount Received",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      PickHeightAndWidth.width10,
                      Expanded(
                        child: CommonDropDownWithoutSearch(
                          borderColor: PickColors.primaryColor,
                          hintText: "Payment Mode",
                          name: 'Payment Mode',
                          items: GlobalList.paymentModeList
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
                          initialValue: _paymentMode,
                          onChanged: (newValue) {
                            setState(
                              () {
                                _paymentMode = newValue.toString();
                              },
                            );
                            debugPrint("----------$_paymentMode");
                          },
                        ),
                      ),
                    ],
                  ),
                  PickHeightAndWidth.height10,
                  CommonTextFieldWithFocus(
                    controller: feesSummeryController,
                    labelText: "Fees Summary",
                    hintText: "Fees Summary",
                    maxLines: 3,
                  ),
                  PickHeightAndWidth.height20,
                  CommonDropDownWithoutSearch(
                    borderColor: PickColors.primaryColor,
                    hintText: "Regards",
                    name: 'Regards',
                    items: GlobalList.regardsName
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
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonMaterialButton(
                    title: "Create Message",
                    onPressed: () {
                      setState(() {
                        _showPreviewMessage = true;
                      });
                    }),
                const SizedBox(height: 10),
                if (_showPreviewMessage)
                  RichText(
                    text: TextSpan(
                      style: CommonTextStyle().authSubTitleTextStyle,
                      children: [
                        TextSpan(text: "Hi,\n${clientNameController.text}\n\n"),
                        // TextSpan(
                        //   text:
                        //       "alekha architects had received your fees payment of Rs. ${amountReceivedController.text} as fees stage ${feesController.text}  for Project No. ${projectNoController.text} on ${dateMeetingController.text} through ${_paymentMode.toString()}.\n\nFees Summary\n${feesSummeryController.text}\n\n",
                        // ),
                        // if (feesSummeryController.text.trim().isNotEmpty) ...[
                        //   TextSpan(text: "Note\n"),
                        //   TextSpan(text: "${feesSummeryController.text}\n\n"),
                        // ],
                        TextSpan(
                          text:
                              "alekha architects had received your fees payment of Rs. ${amountReceivedController.text} as fees stage ${feesController.text}  for Project No. ${projectNoController.text} on ${dateMeetingController.text} through ${_paymentMode.toString()}.\n\n",
                        ),
                        if (feesSummeryController.text.trim().isNotEmpty) ...[
                          const TextSpan(text: "Fees Summary\n"),
                          TextSpan(text: "${feesSummeryController.text}\n\n"),
                          // TextSpan(text: "Note\n"),
                          // TextSpan(text: "${feesSummeryController.text}\n\n"),
                        ],

                        TextSpan(
                            text:
                                "Regards\n${_selectedRegardsType.toString()}\n"),
                        TextSpan(
                          text: "alekha architects",
                          style:
                              CommonTextStyle().authSubTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        color: PickColors.successColor,
                        title: "Share",
                        suffixIcon: PickImages.whatsAppIcon,
                        onPressed: () {
                          // _launchWhatsapp();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonMaterialButton(
                          borderColor: PickColors.authSubTitleTextColor,
                          title: "Copy",
                          suffixIcon: PickImages.copyToClipboardIcon,
                          style: CommonTextStyle().buttonTextStyle,
                          color: PickColors.transparentColor,
                          // onPressed: () {
                          //   String message = "Hi,\n${clientNameController.text}\n\n"
                          //       "alekha architects had received your fees payment of Rs. ${amountReceivedController.text} "
                          //       "as fees stage ${feesController.text} for Project No. ${projectNoController.text} "
                          //       "on ${dateMeetingController.text} through ${_paymentMode.toString()}.\n\n"
                          //       "Fees Summary\n${feesSummeryController.text}\n\n"
                          //       "Regards\n${_selectedRegardsType.toString()}\n"
                          //       "alekha architects";

                          //   Clipboard.setData(ClipboardData(text: message));

                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text("Message copied to clipboard!"),
                          //     ),
                          //   );
                          // },
                          onPressed: () {
                            String message =
                                "Hi,\n${clientNameController.text}\n\n"
                                "alekha architects had received your fees payment of Rs. ${amountReceivedController.text} "
                                "as fees stage ${feesController.text} for Project No. ${projectNoController.text} "
                                "on ${dateMeetingController.text} through ${_paymentMode.toString()}.\n\n";

                            if (feesSummeryController.text.trim().isNotEmpty) {
                              message +=
                                  "Fees Summary\n${feesSummeryController.text}\n\n";
                            }

                            message +=
                                "Regards\n${_selectedRegardsType.toString()}\n"
                                "alekha architects";

                            Clipboard.setData(ClipboardData(text: message));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Message copied to clipboard!"),
                              ),
                            );
                          }),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
