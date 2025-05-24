import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            'Calculator',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns in the grid
              mainAxisSpacing: 8.0, // vertical space between items
              crossAxisSpacing: 8.0, // horizontal space between items
            ),
            itemCount: GlobalList.calculatorList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  if (GlobalList.calculatorList[index]["id"] == "1") {
                    const url =
                        'https://www.civil-engineering-calculators.com/Quantity-estimator/Cement-Concrete-Calculator#google_vignette';
                    await openUrl(url, context);
                  } else {
                    changeScreen(
                      context: context,
                      widget: GlobalList.calculatorList[index]["screen"],
                    );
                  }
                },
                child: IconTitleContainer(
                  mainIcon: GlobalList.calculatorList[index]["icon"],
                  mainText: GlobalList.calculatorList[index]["title"]
                      .toString()
                      .toUpperCase(),
                  subText: "",
                  mainTextTextStyle: CommonTextStyle().sectionTextStyle,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> openUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong!')),
      );
    }
  }
}
