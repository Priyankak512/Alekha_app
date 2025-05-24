// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PythagorasScreen extends StatefulWidget {
  const PythagorasScreen({super.key});

  @override
  State<PythagorasScreen> createState() => _PythagorasScreenState();
}

class _PythagorasScreenState extends State<PythagorasScreen> {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  double? cValue;

  void calculateC() {
    final double? a = double.tryParse(aController.text);
    final double? b = double.tryParse(bController.text);

    if (a != null && b != null) {
      setState(() {
        cValue = sqrt((a * a) + (b * b));
      });
    } else {
      setState(() {
        cValue = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid numbers for a and b")),
      );
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
              'Pythagoras Calculator',
              style: CommonTextStyle().appBarTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWithFocus(
                        controller: aController,
                        labelText: "A",
                        hintText: "A",
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    PickHeightAndWidth.width10,
                    Expanded(
                      child: CommonTextFieldWithFocus(
                        controller: bController,
                        labelText: "B",
                        hintText: "B",
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ],
                ),
                PickHeightAndWidth.height30,
                CommonMaterialButton(
                  color: PickColors.transparentColor,
                  borderColor: PickColors.textfieldBorderColor,
                  title: "Calculate c",
                  onPressed: calculateC,
                ),
                const SizedBox(height: 30),
                if (cValue != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Builder(
                        builder: (_) {
                          final totalInches = cValue!;
                          final feet = totalInches ~/ 12;
                          final inches = totalInches % 12;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: PickColors.textfieldBorderColor)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                                "Value of c = $feet feet ${inches.toStringAsFixed(2)} inches",
                                style:
                                    CommonTextStyle().textFieldTitleTextStyle),
                          );
                        },
                      ),
                      PickHeightAndWidth.height20,
                    ],
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: GlobalList.inchAndFitList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const Divider(),
                          Row(
                            children: [
                              // Inch text
                              Expanded(
                                child: Text(
                                  GlobalList.inchAndFitList[index]["inch"],
                                  style:
                                      CommonTextStyle().textFieldTitleTextStyle,
                                ),
                              ),

                              // Vertical Divider
                              Container(
                                height: 25, // Adjust as needed
                                width: 1,
                                color: PickColors.hintColor,
                              ),

                              // Title text
                              Expanded(
                                flex: 3,
                                child: Text(
                                  GlobalList.inchAndFitList[index]["title"],
                                  textAlign: TextAlign.end,
                                  style:
                                      CommonTextStyle().textFieldTitleTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
