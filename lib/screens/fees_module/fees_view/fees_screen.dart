import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:flutter/material.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
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
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Fees',
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
            itemCount: GlobalList.feesList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  changeScreen(
                    context: context,
                    widget: GlobalList.feesList[index]["screen"],
                  );
                },
                child: IconTitleContainer(
                  mainIcon: GlobalList.feesList[index]["icon"],
                  mainText: GlobalList.feesList[index]["title"].toString(),
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
}
